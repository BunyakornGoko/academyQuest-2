module SystemTestHelpers
  # Takes a screenshot, useful for debugging
  def take_screenshot(name = nil)
    name ||= "screenshot_#{Time.now.utc.iso8601.gsub(/[^0-9]/, '')}"
    begin
      # Ensure directory exists
      FileUtils.mkdir_p(Rails.root.join('tmp', 'capybara'))
      # Take the screenshot
      page.save_screenshot("#{Rails.root.join('tmp', 'capybara')}/#{name}.png")
      puts "Screenshot saved to tmp/capybara/#{name}.png"
    rescue => e
      puts "Could not take screenshot: #{e.message}"
    end
  end
  
  # Wait for page to load completely
  def wait_for_page_load
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until page.evaluate_script('document.readyState') == 'complete'
    end
  rescue => e
    puts "Error waiting for page to load: #{e.message}"
  end
  
  # Fill in form fields for a quest
  def fill_in_quest_form(name:, status: false)
    fill_in "Name", with: name
    
    if status
      check "Status"
    else
      uncheck "Status"
    end
  end
  
  # Submit a form and wait for response
  def submit_form_and_wait
    find("[type='submit']").click
    wait_for_page_load
  end
  
  # Get testid element
  def find_by_testid(testid)
    find("[data-testid='#{testid}']")
  end
end

RSpec.configure do |config|
  config.include SystemTestHelpers, type: :system
end 