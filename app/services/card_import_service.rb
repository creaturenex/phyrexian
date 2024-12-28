# app/services/card_import_service.rb
class CardImportService
  def self.call
    new.call
  end

  def call
    ActiveRecord::Base.transaction do
      import_sections(fetch_card_data)
    end
  end

  private

  def fetch_card_data
    MagicCardScraperService.call
  end

  def import_sections(sections)
    sections.each do |section_data|
      section = create_section(section_data)
      import_cards(section, section_data[:cards])
    end
  end

  def create_section(section_data)
    CardSection.create!(section_type: section_data[:type])
  end

  def import_cards(section, cards_data)
    cards_data.each do |card_data|
      create_card(section, card_data)
    end
  end

  def create_card(section, card_data)
    section.magic_cards.create!(
      name: card_data[:name],
      image_url: card_data[:image]
    )
  end
end
