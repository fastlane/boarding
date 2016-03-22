class InviteController < ApplicationController
  before_action :check_disabled_text
  before_action :set_app_details

  def index
    if user and password
      # default
    else
      render 'environment_error'
    end
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
      if email.split("@").last != ENV["RESTRICTED_DOMAIN"]
        @message = "Sorry! Early access is currently restricted to people within the #{ENV["RESTRICTED_DOMAIN"]} domain."
        @type = "warning"
        render :index
        return
      end
    end

    if ENV["ITC_TOKEN"]
      if ENV["ITC_TOKEN"] != params[:token]
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

    if ENV["ITC_IS_DEMO"]
      @message = t(:message_demo_page)
      @type = "success"
      render :index
      return
    end

    logger.info "Going to create a new tester: #{email} - #{first_name} #{last_name}"

    begin
      login

      tester = Spaceship::Tunes::Tester::Internal.find(config[:email])
      tester ||= Spaceship::Tunes::Tester::External.find(config[:email])
      Helper.log.info "Existing tester #{tester.email}".green if tester

      tester ||= Spaceship::Tunes::Tester::External.create!(email: email,
                                                            first_name: first_name,
                                                            last_name: last_name)

      logger.info "Successfully created tester #{tester.email}"

      if apple_id.length > 0
        logger.info "Addding tester to application"
        tester.add_to_app!(apple_id)
        logger.info "Done"
      end

      if testing_is_live?
        @message = t(:message_success_live)
      else
        @message = t(:message_success_pending)
      end
      @type = "success"
    rescue => ex
      if ex.inspect.to_s.include?"EmailExists"
        @message = t(:message_email_exists)
        @type = "danger"
      else
        Rails.logger.fatal ex.inspect
        Rails.logger.fatal ex.backtrace.join("\n")

        @message = t(:message_error)
        @type = "danger"
      end
    end

    render :index
  end

end
