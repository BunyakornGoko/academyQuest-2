# This file is in spec/support/capybara.rb
require 'capybara/rspec'
require 'selenium-webdriver'

# Fix for Socket::ResolutionError - explicitly use IP instead of hostname
Capybara.server_host = '127.0.0.1'
Capybara.server = :puma, { Silent: true }

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1366,768')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Add selenium_chrome_headless for Rails system tests compatibility
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')
  
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Configure Capybara
Capybara.configure do |config|
  config.default_driver = :rack_test  # Use most basic driver by default
  config.javascript_driver = :selenium_chrome_headless
  config.default_max_wait_time = 5
  config.default_selector = :css
  config.app_host = "http://#{Capybara.server_host}"
end

# Ensure screenshot directory exists and sessions are cleaned up
RSpec.configure do |config|
  config.before(:each, type: :system) do
    # Ensure directory for screenshots exists
    FileUtils.mkdir_p(Rails.root.join('tmp', 'capybara'))
  end
  
  config.after(:each) do
    Capybara.reset_sessions!
  end
end