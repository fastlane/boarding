<h3 align="center">
  <a href="https://github.com/KrauseFx/fastlane">
    <img src="assets/fastlane.png" width="100" />
    <br />
    fastlane
  </a>
</h3>
<p align="center">
  <a href="https://github.com/KrauseFx/deliver">deliver</a> &bull;
  <a href="https://github.com/KrauseFx/snapshot">snapshot</a> &bull;
  <a href="https://github.com/KrauseFx/frameit">frameit</a> &bull;
  <a href="https://github.com/KrauseFx/PEM">PEM</a> &bull;
  <a href="https://github.com/KrauseFx/sigh">sigh</a> &bull;
  <a href="https://github.com/KrauseFx/produce">produce</a> &bull;
  <a href="https://github.com/KrauseFx/cert">cert</a> &bull;
  <a href="https://github.com/KrauseFx/codes">codes</a>
</p>
-------

<p align="center">
  <img src="assets/boarding.png" width="470">
</p>
-------

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/fastlane/boarding)
[![Twitter: @KauseFx](https://img.shields.io/badge/contact-@KrauseFx-blue.svg?style=flat)](https://twitter.com/KrauseFx)
[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/fastlane/boarding/blob/master/LICENSE)


Get in contact with the developer on Twitter: [@KrauseFx](https://twitter.com/KrauseFx/)


-------
<p align="center">
    <a href="#whats-spaceship">Why?</a> &bull;
    <a href="#usage">Usage</a> &bull;
    <a href="#installation">Installation</a> &bull;
    <a href="#technical-details">Technical Details</a> &bull;
    <a href="#need-help">Need help?</a>
</p>

-------

<h5 align="center"><code>boarding</code> is part of <a href="https://fastlane.tools">fastlane</a>: connect all deployment tools into one streamlined workflow.</h5>

# What's boarding?

> Have you ever been to an airport, where you had to ask the manager of the airport if you can board now? Once the manager agrees, you'll be carried from your check-in to your gate into your plane.

Because that's what you do right now as an app developer when you want to add a new tester to your TestFlight app: 

[Open Screenshots](https://raw.githubusercontent.com/fastlane/boarding/master/OldWay.jpg)

Why don't you have a simple web site you can share with potential testers (e.g. email newsletter, Facebook, Twitter) on which people interested in trying out your new app can just `board` on their own?

Thanks to [spaceship.airforce](https://spacehip.airforce) (oh well, I really talk a lot about flying :rocket:) it now possible to automate the baording process for your TestFlight beta testers.

Just click the `Deploy Now` button below, login with your Heroku account, enter your iTunes Connect credentials and you're done!

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/fastlane/boarding)

# Getting Started

## Security

To secure your webpage, you only have to set the `ITC_TOKEN` environment variable to any password. 

- You can send your users the link and tell them the password
- You can send them the direct link including the token like this: https://url.com/?token=[password]

## Available environment variables

**Required:**

- `ITC_USER` iTunes Connect username
- `ITC_PASSWORD` iTunes Connect password
- `ITC_APP_ID` The Apple ID or Bundle Identifier of your app

**Optional:**
- `ITC_GROUP_NAME` The name of the group the user should be added to. `Boarding` by default
- `ITC_TOKEN` Set a password to protect your website from random people signing up

# How does this work?

`boarding` is part of [fastlane](https://fastlane.tools), which helps you automate everything you usually do manually as an iOS developer. Using [spaceship.airforce](https://spacehip.airforce) it is possible to manage testers, builds, metadata, certificates and so much more.


# Update to a new version

There are 2 ways to update your Heroku application:

### Recommended: Using the terminal

- Install the Heroku toolbelt and `heroku login`
- Clone your application using `heroku clone --app [heroku_app_name]`
- `cd [heroku_app_name]`
- `git pull https://github.com/fastlane/boarding`
- `git push`

### Using Heroku website

- Delete your application on [heroku.com](https://heroku.com)
- [Create a new boarding application](https://heroku.com/deploy?template=https://github.com/fastlane/boarding)
- Enter your user credentials again

##### [Like this tool? Be the first to know about updates and new fastlane tools](https://tinyletter.com/krausefx)

# License
This project is licensed under the terms of the MIT license. See the LICENSE file.

# Contributing

1. Create an issue to start a discussion about your idea
2. Fork it (https://github.com/fastlane/boarding/fork)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
