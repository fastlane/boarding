require 'spaceship'
class InviteController < ApplicationController
  before_action :set_app_details
  before_action :check_disabled_text

  skip_before_filter :verify_authenticity_token

  def index
    if boarding_service.user and boarding_service.password
      # default
    else
      render 'environment_error'
    end
  rescue => ex
    update_spaceship_message
    raise ex
  end

  def update_spaceship_message
    Rails.logger.fatal("--------------------------------------------------------------------------------")
    Rails.logger.fatal("Error rendering the page, make sure to update to the latest version of spaceship")
    Rails.logger.fatal("More information about how to do so can be found on the project README")
    Rails.logger.fatal("--------------------------------------------------------------------------------")
  end

  def submit
    if @message # from a `before_action`
      render :index
      return
    end
    
    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]

    if ENV["RESTRICTED_DOMAIN"]
      domains = ENV["RESTRICTED_DOMAIN"].split(",")
      unless domains.include?(email.split("@").last)
        if domains.count == 1
          @message = "Sorry! Early access is currently restricted to people within the #{domains.first} domain."
        else
          @message = "Sorry! Early access is currently restricted to people within the following domains: (#{domains.join(", ")})"
        end
        @type = "warning"
        render :index
        return
      end
    end

    if boarding_service.itc_token
      if boarding_service.itc_token != params[:token]
        @message = t(:message_invalid_password)
        @type = "danger"
        render :index
        return
      end
    end
    
    if email.length == 0
      render :index
      return
    end

    if boarding_service.is_demo
      @message = t(:message_demo_page)
      @type = "success"
      render :index
      return
    end

    logger.info "Creating a new tester: #{email} - #{first_name} #{last_name}"

    begin
      create_and_add_tester(email, first_name, last_name)
    rescue => ex
      Rails.logger.fatal ex.inspect
      Rails.logger.fatal ex.backtrace.join("\n")

      @message = [t(:message_error), ex.to_s].join(": ")
      @type = "danger"
    end

    render :index
  rescue => ex
    update_spaceship_message
    raise ex
  end

  private
    def create_and_add_tester(email, first_name, last_name)
      add_tester_response = boarding_service.add_tester(email, first_name, last_name)
      @message = add_tester_response.message
      @type = add_tester_response.type
    end

    def boarding_service
      BOARDING_SERVICE
    end

    def app_metadata
      Rails.cache.fetch('appMetadata', expires_in: 10.minutes) do
        {
          icon_url: boarding_service.app.app_icon_preview_url,
          title: boarding_service.app.name
        }
      end
    end

    def set_app_details
      @metadata = app_metadata
      @title = @metadata[:title]
    end

    def check_disabled_text
      if boarding_service.itc_closed_text
        @message = boarding_service.itc_closed_text
        @type = "warning"
      end
    end
end
