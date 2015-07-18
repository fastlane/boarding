class InviteController < ApplicationController
  before_action :set_app_icon

  def index
    if user and password
      # default
    else
      render 'environment_error'
    end
  end

  def submit
    email = params[:email]
    first_name = params[:last_name]
    last_name = params[:first_name]
    group_name = ENV["ITC_GROUP_NAME"] || "Boarding"

    logger.info "Going to create a new tester: #{email} - #{first_name} #{last_name}"

    begin
      login
      tester = Spaceship::Tunes::Tester::External.create!(email: email, 
                                                          first_name: first_name, 
                                                          last_name: last_name,
                                                          group: group_name)

      logger.info "Successfully created tester #{tester.email}"

      if apple_id.length > 0
        tester.add_to_app!(apple_id)
      end

      @message = "Successfully added you as tester. You'll be notified once the next build is available"
      @type = "success"
    rescue => ex
      if ex.inspect.to_s.include?"EmailExists"
        @message = "Email address is already registered"
        @type = "danger"
      else
        Rails.logger.fatal ex.inspect
        Rails.logger.fatal ex.backtrace.join("\n")

        @message = "Something went wrong, please contact the application owner"
        @type = "danger"
      end
    end

    render :index
  end

  private
    def user
      ENV["ITC_USER"] || ENV["FASTLANE_USER"]
    end

    def password
      ENV["ITC_PASSWORD"] || ENV["FASTLANE_PASSWORD"]
    end

    def apple_id
      Rails.logger.error "No app to add this tester to provided, use the `ITC_APP_ID` environment variable" unless ENV["ITC_APP_ID"]

      ENV["ITC_APP_ID"].to_s
    end

    def app
      login

      @app ||= Spaceship::Tunes::Application.find(apple_id)
    end

    def app_icon_url
      Rails.cache.fetch('appIcon', expires_in: 5.minutes) do
        app.app_icon_preview_url
      end
    end

    def login
      return if @spaceship
      @spaceship = Spaceship::Tunes.login(user, password)
    end

    def set_app_icon
      @app_icon_url = app_icon_url
    end
end
