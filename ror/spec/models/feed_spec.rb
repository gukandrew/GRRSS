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
require 'rails_helper'

RSpec.describe Feed, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
