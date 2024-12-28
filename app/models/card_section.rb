# app/models/card_section.rb
class CardSection < ApplicationRecord
  has_many :magic_cards, dependent: :destroy

  validates :section_type, presence: true
end
