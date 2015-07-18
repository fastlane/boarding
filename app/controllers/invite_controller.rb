class InviteController < ApplicationController
  def index

  end

  def submit
    email = params[:email]
    first_name = params[:last_name]
    last_name = params[:first_name]

    logger.info "Going to create a new tester: #{email} - #{first_name} #{last_name}"

    user = ENV["ITC_USER"] || ENV["FASTLANE_USER"]
    password = ENV["ITC_PASSWORD"] || ENV["FASTLANE_PASSWORD"]
    Spaceship::Tunes.login(user, password)
    tester = Spaceship::Tunes::Tester::External.create!(email: email, first_name: first_name, last_name: last_name)

    logger.info "Successfully created tester #{email}"

    if ENV["APP_ID"].to_s.length > 0
      tester.add_to_app!(ENV["APP_ID"])
    else
      logger.info "No app to add this tester to provided, use the `APP_ID` environment variable"
    end
  end
end
