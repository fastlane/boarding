class BaseController < ApplicationController
	before_action :set_app_details
	
  protected
    def user
      ENV["ITC_USER"] || ENV["FASTLANE_USER"]
    end

    def password
      ENV["ITC_PASSWORD"] || ENV["FASTLANE_PASSWORD"]
    end

    def apple_id
      Rails.logger.error "No app to add this tester to provided, use the `ITC_APP_ID` environment variable" unless ENV["ITC_APP_ID"]

      Rails.cache.fetch('AppID', expires_in: 10.minutes) do
        if ENV["ITC_APP_ID"].include?"." # app identifier
          login
          app = Spaceship::Application.find(ENV["ITC_APP_ID"])
          app.apple_id
        else
          ENV["ITC_APP_ID"].to_s
        end
      end
    end

    def app
      login

      @app ||= Spaceship::Tunes::Application.find(ENV["ITC_APP_ID"])

      raise "Could not find app with ID #{apple_id}" unless @app

      @app
    end  

    def login
      return if @spaceship
      @spaceship = Spaceship::Tunes.login(user, password)
      @spaceship.select_team
    end    

    def app_metadata
      Rails.cache.fetch('appMetadata', expires_in: 10.minutes) do
        {
          icon_url: app.app_icon_preview_url,
          title: app.name
        }
      end
    end  
    
    def set_app_details
      @metadata = app_metadata
      @title = @metadata[:title]
    end
end