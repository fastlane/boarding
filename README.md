<h3 align="center">
  <a href="https://github.com/fastlane/fastlane">
    <img src="https://raw.githubusercontent.com/fastlane/boarding/master/app/assets/images/fastlane.png" width="100" />
    <br />
    fastlane
  </a>
</h3>
<p align="center">
  <a href="https://github.com/fastlane/fastlane/tree/master/deliver">deliver</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/snapshot">snapshot</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/frameit">frameit</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/pem">pem</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/sigh">sigh</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/produce">produce</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/cert">cert</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/spaceship">spaceship</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/pilot">pilot</a> &bull;
  <b>boarding</b> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/gym">gym</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/scan">scan</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/match">match</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/precheck">precheck</a>
</p>

---

<p align="center">
  <img src="https://raw.githubusercontent.com/fastlane/boarding/master/assets/BoardingHuge.png" width="650">
</p>

---

[![Twitter: @FastlaneTools](https://img.shields.io/badge/contact-@FastlaneTools-blue.svg?style=flat)](https://twitter.com/FastlaneTools)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/fastlane/boarding/blob/master/LICENSE)

Get in contact with the developers on Twitter: [@FastlaneTools](https://twitter.com/FastlaneTools/)

---

<p align="center">
    <a href="#whats-boarding">Why?</a> &bull;
    <a href="#getting-started">Getting Started</a> &bull;
    <a href="#how-does-this-work">Technical Details</a> &bull;
    <a href="#customize">Customize</a> &bull;
    <a href="#update-to-a-new-version">Update</a>
</p>

---

<h5 align="center"><code>boarding</code> is part of <a href="https://fastlane.tools">fastlane</a>: connect all deployment tools into one streamlined workflow.</h5>

# What's boarding?

Instantly create a simple signup page for TestFlight beta testers.

> Have you ever been to an airport, where you had to ask the manager of the airport if you can board now? Once the manager agrees, you'll be carried from your check-in to your gate into your plane.

Because that's what you do right now as an app developer when you want to add a new tester to your TestFlight app: [Open Screenshots](https://raw.githubusercontent.com/fastlane/boarding/master/assets/OldWay.jpg)

Why don't you have a simple web site you can share with potential testers (e.g. email newsletter, Facebook, Twitter) on which people interested in trying out your new app can just `board` on their own?

![BoardingScreenshot](https://raw.githubusercontent.com/fastlane/boarding/master/assets/BoardingScreenshot.png)

Thanks to [spaceship.airforce](https://spaceship.airforce) (oh well, I really talk a lot about flying :rocket:) it is now possible to automate the boarding process for your TestFlight beta testers.

### Example

##### Take a look at this live example page: [boarding.herokuapp.com](https://boarding.herokuapp.com)

[Like this tool? Be the first to know about updates and new fastlane tools](https://tinyletter.com/fastlane-tools)

# Getting Started

Assuming you already have an [Azure](https://www.azure.com/) account follow those steps:

* [![Deploy to Azure](https://azuredeploy.net/deploybutton.svg)](https://deploy.azure.com/?repository=https://github.com/fastlane/boarding)
* Enter your iTunes Connect credentials and the bundle identifier of your app. This will all be stored on your own Heroku instance as environment variables
* It can take up to 5 minutes until everything is loaded.

Assuming you already have a [Heroku](https://www.heroku.com/) account follow those steps:

* [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://www.heroku.com/deploy?template=https://github.com/fastlane/boarding)
* Enter your iTunes Connect credentials and the bundle identifier of your app. This will all be stored on your own Heroku instance as environment variables
* Click on `View` once the setup is complete and start sharing the URL

`boarding` does all kinds of magic for you, like fetching the app name and app icon.

Heroku is free to use for the standard machine. If you need a Heroku account, ask your back-end team if you already have a company account.

---

![SetupGif](https://raw.githubusercontent.com/fastlane/boarding/master/assets/BoardingSetup.gif)

---

If your account is protected using 2-factor author, follow the [2 step verification guide](https://github.com/fastlane/fastlane/blob/master/spaceship/README.md#2-step-verification).

## Security

To secure your webpage, you only have to set the `ITC_TOKEN` environment variable to any password.

* You can send your users the link and tell them the password
* You can send them the direct link including the token like this: https://url.com/?token=[password]

## Available environment variables

**Required:**

* `ITC_USER` iTunes Connect username
* `ITC_PASSWORD` iTunes Connect password
* `ITC_APP_ID` The Apple ID or Bundle Identifier of your app

**Optional:**

* `ITC_TOKEN` Set a password to protect your website from random people signing up
* `ITC_CLOSED_TEXT` Set this text to temporary disable enrollment of new beta testers
* `RESTRICTED_DOMAIN` Set this domain (in the format `domain.com`) to restrict users with emails in another domain from signing up. This list supports multiple domains by setting it to a comma delimited list (`domain1.com,domain2.com`)
* `FASTLANE_ITC_TEAM_NAME` If you're in multiple teams, enter the name of your iTC team here. Make sure it matches.
* `IMPRINT_URL` If you want a link to an imprint to be shown on the invite page.

## Custom Domain

With Heroku you can easily use your own domain, follow [this guide](https://devcenter.heroku.com/articles/custom-domains).

With Azure you can easily use your own domain, follow [this guid](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain?toc=%2fazure%2fapp-service%2fcontainers%2ftoc.json)

## Alternative Setup Options

* Docker image: [emcniece/docker-boarding](https://github.com/emcniece/docker-boarding)

# How does this work?

`boarding` is part of [fastlane](https://fastlane.tools), which helps you automate everything you usually do manually as an iOS developer.

Using [spaceship.airforce](https://spaceship.airforce) it is possible to manage testers, builds, metadata, certificates and so much more.

This repository is a simple Rails application with most code in these files:

* [invite_controller.rb](https://github.com/fastlane/boarding/blob/master/app/controllers/invite_controller.rb)
* [invite/index.html.erb](https://github.com/fastlane/boarding/blob/master/app/views/invite/index.html.erb)

![BoardingOverview](https://raw.githubusercontent.com/fastlane/boarding/master/assets/BoardingOverview.png)

More information about this automation process can be found [here](https://krausefx.com/blog/letting-computers-do-the-hard-work).

# Customize

If you want to change the design, layout or even add new features:

* Install the [Heroku toolbelt](https://toolbelt.heroku.com/) and `heroku login`
* Clone your application using `heroku git:clone --app [heroku_app_name]` (it will be an empty repo)
* `cd [heroku_app_name]`
* `git pull https://github.com/fastlane/boarding`
* Modify the content, in particular the files that are described above.
* Test it locally by running `ITC_USER="email" ITC_... rails s` and opening [http://127.0.0.1:3000](http://127.0.0.1:3000)
* Commit the changes
* `git push`

It is recommended to also store your version in your git repo additionally to Heroku.

# Update to a new version

From time to time there will be updates to `boarding`. There are 2 ways to update your Heroku application:

### Recommended: Using the terminal

* Install the [Heroku toolbelt](https://toolbelt.heroku.com/) and `heroku login`
* Clone your application using `heroku git:clone --app [heroku_app_name]` (it will be an empty repo)
* `cd [heroku_app_name]`
* `git pull https://github.com/fastlane/boarding`
* `git push`

### Using Heroku website

* Delete your application on [heroku.com](https://www.heroku.com/)
* [Create a new boarding application](https://www.heroku.com/deploy?template=https://github.com/fastlane/boarding)
* Enter your user credentials again

### Using Azure website

* Navigate to the [Azure Portal](https://portal.azure.com/)
* Login and navigate to your WebApp
* On `Overview` hit the restart button

# Managing Azure version

If you installed `boarding` using the `deploy to Azure` button, `boarding` will be deployed in an Azure WebApp for containers.
This means that azure is running the [docker-version](https://github.com/emcniece/docker-boarding) of `boarding`.

### Setting optional parameters in Azure

In order to set the optional parameters for `boarding` follow these steps:

* Navigate to the [Azure Portal](https://portal.azure.com/)
* Login and navigate to your WebApp
* Under `Settings` click `Application settings`
* Click the link `+ Add new setting` and add the the optional parameter i.e. `ITC_CLOSED_TEXT` = `We are closed!`
* Hit `Save` and navigate to `Overview`
* On `Overview` hit the restart button

### Troubleshoot boarding on Azure

When you run `boarding` on Azure, it could happen that you run into an HttpStatus 503 showing `Service Unavailable`
There can be multiple reasons for that:

* `boarding` isn't yet fully loaded. Wait a few minutes hit refresh.
* The provided parameters are wrong (`ITC_USER`, `ITC_PASSWORD`, `ITC_APP_ID`). Please go to the settings in Azure and check if they are right.

For further troubleshooting, please got to [Azure App Service on Linux FAQ](https://docs.microsoft.com/en-us/azure/app-service/containers/app-service-linux-faq)

##### [Like this tool? Be the first to know about updates and new fastlane tools](https://tinyletter.com/krausefx)

### Special thanks

Special thanks to [@lee_moonan](https://twitter.com/lee_moonan) for designing the awesome logo.

# Development Setup
1. `gem install bundler`
1. `bundle install`
1. Create a `.env.local` file with the following contents:
    ```
    # Required
    ITC_APP_ID=<your_app_id>
    ITC_USER=<your_email>
    ITC_PASSWORD=<your_password>

    # Optional
    FASTLANE_ITC_TEAM_NAME=<your_team_name>
    ITC_APP_TESTER_GROUPS=<your_groups>
    ITC_TOKEN=<your_token>
    GA_PROPERTY_ID=<your_ga_property_id>
    IMPRINT_URL=<your_url>
    ```
1. `bundle exec rails s`

# Code of Conduct

Help us keep `boarding` open and inclusive. Please read and follow our [Code of Conduct](https://github.com/fastlane/code-of-conduct).

# License

This project is licensed under the terms of the MIT license. See the LICENSE file.

> This project and all fastlane tools are in no way affiliated with Apple Inc. This project is open source under the MIT license, which means you have full access to the source code and can modify it to fit your own needs. All fastlane tools run on your own computer or server, so your credentials or other sensitive information will never leave your own computer. You are responsible for how you use fastlane tools.
