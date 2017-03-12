module Browserable
  extend ActiveSupport::Concern

  def browser
    @_browser ||= Watir::Browser.new :phantomjs, args: phantom_switches
  end

  def phantom_switches
    ['--load-images=no', '--ignore-ssl-errors=yes']
  end

  def turo_login
    browser.goto("https://turo.com/dashboard")
    browser.text_field(name: 'username').set(ENV["TURO_USERNAME"])
    browser.text_field(name: 'password').set(ENV["TURO_PASSWORD"])
    browser.button(id: 'submit').click
    sleep(3)
  end

end
