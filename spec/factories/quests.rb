FactoryBot.define do
  factory :quest do
    sequence(:name) { |n| "Test Quest #{n}" }
    status { [true, false].sample }
  end
end
