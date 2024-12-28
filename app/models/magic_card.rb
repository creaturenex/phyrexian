# app/models/magic_card.rb
class MagicCard < ApplicationRecord
  belongs_to :card_section

  validates :name, presence: true
  validates :image_url, presence: true
end
