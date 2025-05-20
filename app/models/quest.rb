class Quest < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :status, inclusion: { in: [true, false] }
end
