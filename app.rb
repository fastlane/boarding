require 'sinatra/base'
require 'active_support'
require 'spaceship'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'tilt/erb'

class Boarding < Sinatra::Base

  configure :production, :development do
    enable :logging
    enable :sessions

    file = File.new(File.join(settings.root, 'log', "#{settings.environment}.log"), 'a+')
    file.sync = true
    use Rack::CommonLogger, file

    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path = Dir[File.join(settings.root, 'config', 'locales', '*.yml')]
    I18n.backend.load_translations

    I18n.available_locales = %w(nl cs da de en es fr it ru zh-TW)
  end

  before do
    I18n.locale = env.http_accept_language.preferred_language_from(I18n.available_locales)
    check_disabled_text
    verify_user_and_password
    @metadata = app_metadata
    @title = @metadata[:title]
  end

  helpers do
    def t(*args)
      I18n.t(*args)
    end
  end

  get '/' do
    erb :index
  end

  post '/submit' do
    if @message # from a `before_action`
      halt erb(:index)
    end

    email = params[:email]
    first_name = params[:first_name]
    last_name = params[:last_name]

    if ENV['RESTRICTED_DOMAIN']
      if email.split('@').last != ENV['RESTRICTED_DOMAIN']
        @message = "Sorry! Early access is currently restricted to people within the #{ENV["RESTRICTED_DOMAIN"]} domain."
        @type = 'warning'
        halt erb(:index)
      end
    end

    if ENV['ITC_TOKEN']
      if ENV['ITC_TOKEN'] != params[:token]
        @message = t(:message_invalid_password)
        @type = 'danger'
        halt erb(:index)
      end
    end

    if email.length == 0
      halt erb(:index)
    end

    if ENV['ITC_IS_DEMO']
      @message = t(:message_demo_page)
      @type = 'success'
      halt erb(:index)
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
        logger.info 'Addding tester to application'
        tester.add_to_app!(apple_id)
        logger.info 'Done'
      end

      if testing_is_live?
        @message = t(:message_success_live)
      else
        @message = t(:message_success_pending)
      end
      @type = 'success'
    rescue => ex
      if ex.inspect.to_s.include? 'EmailExists'
        @message = t(:message_email_exists)
        @type = 'danger'
      else
        logger.fatal ex.inspect
        logger.fatal ex.backtrace.join("\n")

        @message = t(:message_error)
        @type = 'danger'
      end
    end

    erb :index
  end

  private

    def user
      ENV['ITC_USER'] || ENV['FASTLANE_USER']
    end

    def password
      ENV['ITC_PASSWORD'] || ENV['FASTLANE_PASSWORD']
    end

    def apple_id
      logger.error 'No app to add this tester to provided, use the `ITC_APP_ID` environment variable' unless ENV['ITC_APP_ID']

      cache.fetch('AppID', expires_in: 10.minutes) do
        if ENV['ITC_APP_ID'].include? '.' # app identifier
          login
          app = Spaceship::Application.find(ENV['ITC_APP_ID'])
          app.apple_id
        else
          ENV['ITC_APP_ID'].to_s
        end
      end
    end

    def app
      login

      @app ||= Spaceship::Tunes::Application.find(ENV['ITC_APP_ID'])

      raise "Could not find app with ID #{apple_id}" unless @app

      @app
    end

    def app_metadata
      cache.fetch('appMetadata', expires_in: 10.minutes) do
        {
          icon_url: app.app_icon_preview_url,
          title: app.name
        }
      end
    end

    def login
      return if @spaceship
      @spaceship = Spaceship::Tunes.login(user, password)
      if ENV['ITC_TEAM_ID']
        @spaceship.team_id = ENV['ITC_TEAM_ID']
      else
        @spaceship.select_team
      end
    end

    def check_disabled_text
      if ENV['ITC_CLOSED_TEXT']
        @message = ENV['ITC_CLOSED_TEXT']
        @type = 'warning'
      end
    end

    def verify_user_and_password
      unless user and password
        halt erb(:environment_error)
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

    def cache
      @store ||= ActiveSupport::Cache.lookup_store(:memory_store)
    end

end
