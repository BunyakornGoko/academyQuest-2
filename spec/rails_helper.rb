# This file is in spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Configure system tests
RSpec.configure do |config|
  # Default hostname for system tests
  Capybara.server_port = 42424 
  Capybara.server_host = '127.0.0.1'
  Capybara.app_host = "http://127.0.0.1:#{Capybara.server_port}"

  # Configure drivers
  config.before(:each, type: :system) do
    # Default to rack_test driver
    driven_by(:rack_test)
  end

  config.before(:each, type: :system, js: true) do
    # Use headless Chrome for JS tests
    driven_by(:selenium_chrome_headless)
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  
  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods
end