# == Schema Information
#
# Table name: feeds
#
#  id         :bigint           not null, primary key
#  url        :string
#  name       :string
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :feed do
    sequence(:url) { |n| "http://example.com/#{n}" }
    sequence(:name) { |n| "Feed #{n}" }
    active { true }
  end
end
