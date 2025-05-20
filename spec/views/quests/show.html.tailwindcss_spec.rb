require 'rails_helper'

RSpec.describe "quests/show", type: :view do
  before(:each) do
    assign(:quest, Quest.create!(
      name: "Name",
      status: false
    ))
  end

  it "renders attributes in <p>" do
    render
    assert_select "h1.font-bold", text: "Name"
    assert_select "span.bg-yellow-100", text: "In Progress"
  end
end
