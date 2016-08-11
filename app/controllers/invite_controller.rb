class InviteController < BaseController
  before_action :check_disabled_text

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

      tester = Spaceship::Tunes::Tester::Internal.find(email)
      tester ||= Spaceship::Tunes::Tester::External.find(email)
      logger.info "Existing tester #{tester.email}" if tester

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

  private
    def check_disabled_text
      if ENV["ITC_CLOSED_TEXT"]
        @message = ENV["ITC_CLOSED_TEXT"]
        @type = "warning"
      end
    end

    # @return [Boolean] Is at least one TestFlight beta testing build available?
    def testing_is_live?
      app.build_trains.each do |version, train|
        if train.external_testing_enabled
          train.builds.each do |build|
            return true if build.external_testing_enabled
          end
        end
      end
      return false
    end
end
