# spec/features/product_order_spec.rb
require 'rails_helper'

RSpec.feature "Product Ordering", type: :feature, js: true do
  before do
    # Create test data
    @product = FactoryBot.create(:product, name: "Test Product", price: 19.99)
    @user = FactoryBot.create(:user, email: "customer@example.com", password: "password123")
  end

  scenario "User logs in and orders a product" do
    # Log in
    visit new_user_session_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"
    click_button "Log in"
    
    expect(page).to have_content("Signed in successfully")
    
    # Navigate to products page
    visit products_path
    expect(page).to have_content(@product.name)
    
    # Add product to cart
    within "#product_#{@product.id}" do
      click_button "Add to Cart"
    end
    
    # Go to cart
    visit cart_path
    expect(page).to have_content(@product.name)
    expect(page).to have_content("$19.99")
    
    # Proceed to checkout
    click_link "Checkout"
    
    # Fill in shipping details
    fill_in "Address", with: "123 Test St"
    fill_in "City", with: "Test City"
    select "United States", from: "Country"
    fill_in "Zip code", with: "12345"
    
    # Select payment method
    choose "Credit Card"
    
    # Complete order
    click_button "Place Order"
    
    # Verify order confirmation
    expect(page).to have_content("Order Confirmed")
    expect(page).to have_content("Order #")
    expect(page).to have_content(@product.name)
  end
end