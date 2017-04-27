require "spaceship"

class AddTesterResponse
  attr_accessor :message
  attr_accessor :type
end  

class BoardingService
  include AbstractController::Translation

  attr_accessor :app
  attr_accessor :app_id
  attr_accessor :user
  attr_accessor :password
  attr_accessor :tester_groups
  attr_accessor :is_demo
  attr_accessor :itc_token
  attr_accessor :itc_closed_text

  def initialize(app_id: ENV["ITC_APP_ID"],
                   user: ENV["ITC_USER"] || ENV["FASTLANE_USER"],
               password: ENV["ITC_PASSWORD"] || ENV["FASTLANE_PASSWORD"],
          tester_groups: ENV["ITC_APP_TESTER_GROUPS"].to_s.split(/\s*,\s*/))
    @app_id = app_id
    @user = user
    @password = password
    @tester_groups = tester_groups
    @is_demo = ENV["ITC_IS_DEMO"]
    @itc_token = ENV["ITC_TOKEN"]
    @itc_closed_text = ENV["ITC_CLOSED_TEXT"]

    ensure_values
  end

  def add_tester(email, first_name, last_name)
    tester = Spaceship::Tunes::Tester::External.find_by_app(app.apple_id, email)
    add_tester_response = AddTesterResponse.new

    if tester
      Rails.logger.info "Tester #{email} already exists on application"
      add_tester_response.message = t(:message_email_exists)
      add_tester_response.type = "danger"
    elsif tester = Spaceship::Tunes::Tester::External.find(email)
      Rails.logger.info "Tester #{email} exists in iTunesConnect but not on application"
      add_tester_response.message = t(:message_email_exists)
      add_tester_response.type = "danger"
    else
      tester = Spaceship::Tunes::Tester::External.create!(email: email, first_name: first_name, last_name: last_name)
      Rails.logger.info "Successfully created tester #{email}"
      if testing_is_live?
        add_tester_response.message = t(:message_success_live)
      else
        add_tester_response.message = t(:message_success_pending)
      end
      add_tester_response.type = "success"
    end

    if app.apple_id.length > 0
      Rails.logger.info "Addding tester to application to groups: #{tester_groups.to_s}"
      add_tester_to_groups!(tester: tester, app: app, groups: tester_groups)
      Rails.logger.info "Done"
    end
    return add_tester_response
  end

  private
    def ensure_values
      error_message = []

      error_message << "Environment variable `ITC_APP_ID` required" if @app_id.empty?
      error_message << "Environment variable `ITC_USER` or `FASTLANE_USER` required" if @user.empty?
      error_message << "Environment variable `ITC_PASSWORD` or `FASTLANE_PASSWORD`" if @password.empty?

      spaceship = Spaceship::Tunes.login(@user, @password)
      spaceship.select_team

      @app ||= Spaceship::Tunes::Application.find(@app_id)      
      if @app.nil?
        error_message << "Could not find app with ID #{app_id}"
        
        # we cannot continue if @app is nil since we use it later to continue startup validation
        raise error_message.join("\n")
      end    

      test_flight_groups = Spaceship::TestFlight::Group.filter_groups(app_id: @app.apple_id)
      test_flight_group_names = test_flight_groups.map { |group| group.name }.to_set
      tester_groups.select do |group_name|
        error_message << "TestFlight missing group `#{group_name}`, You need to first create this group in iTunes Connect." if !test_flight_group_names.include?(group_name)
      end

      raise error_message.join("\n") if error_message.length > 0
    end

    def add_tester_to_groups!(tester: nil, app: nil, groups: nil)
      if groups.nil?
          default_external_group = self.default_external_group
          if default_external_group.nil?
            Rails.logger.error "The app #{self.name} does not have a default external group. Please make sure to pass group names to the `:groups` option."
          end
          test_flight_groups = [default_external_group]
      else
        test_flight_groups = Spaceship::TestFlight::Group.filter_groups(app_id: app.apple_id) do |group| 
          groups.include?(group.name) 
        end

        Rails.logger.error "There are no groups available matching the names passed to the `:groups` option." if test_flight_groups.empty?
      end
      
      test_flight_groups.each { |group| group.add_tester!(tester) }
    end

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
