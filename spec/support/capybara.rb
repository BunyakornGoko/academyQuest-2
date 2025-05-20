# This file is in spec/support/capybara.rb
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1366,768')
  options.add_argument('--no-sandbox')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Configure Capybara
Capybara.configure do |config|
  config.default_driver = :chrome
  config.javascript_driver = :headless_chrome
  config.default_max_wait_time = 5
  config.server = :puma, { Silent: true }
  config.default_selector = :css
end

# Ensure the browser is closed after each test
RSpec.configure do |config|
  config.after(:each) do
    Capybara.reset_sessions!
  end
end