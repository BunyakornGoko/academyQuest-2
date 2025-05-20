require 'rails_helper'

RSpec.describe "quests/index", type: :view do
  before(:each) do
    assign(:quests, [
      Quest.create!(
        name: "Name",
        status: false
      ),
      Quest.create!(
        name: "Name",
        status: false
      )
    ])
  end

  it "renders a list of quests" do
    render
    # Check for quest names in h2 elements
    assert_select "h2.text-xl", text: "Name", count: 2
    # Check for status indicators
    assert_select "span.bg-yellow-100", text: "In Progress", count: 2
  end
end
