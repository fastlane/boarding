class InviteController < ApplicationController
  def index
    if user and password
      # default
      @app_icon_url = app_icon_url
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
    rescue => ex
      Rails.logger.fatal ex.inspect
      Rails.logger.fatal ex.backtrace.join("\n")
      render 'register_error'
    end
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

    def app_icon_url
      Rails.cache.fetch("appIcon/#{apple_id}", expires_in: 2.minutes) do
        begin
          login
          application = Spaceship::Tunes::Application.find(apple_id)
          application.app_icon_preview_url
        rescue => ex
          # ignoring the fact that we don't have an app icon
        end
      end
    end

    def login
      return if @spaceship
      @spaceship = Spaceship::Tunes.login(user, password)
    end
end
