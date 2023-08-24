class Item < ApplicationRecord
  belongs_to :feed, optional: true
end
