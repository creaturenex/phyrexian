# app/services/magic_card_scraper_service.rb
class MagicCardScraperService
  CARD_GALLERY_URL = "https://magic.wizards.com/en/news/card-image-gallery/phyrexia-all-will-be-one".freeze

  def self.call
    new.call
  end

  def call
    setup_driver
    fetch_sections
  ensure
    cleanup_driver
  end

  private

  attr_reader :driver

  def setup_driver
    options = chrome_options
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  def chrome_options
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    options
  end

  def fetch_sections
    driver.get(CARD_GALLERY_URL)
    wait_for_content
    parse_sections
  end

  def wait_for_content
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_elements(css: "h2.strike-through").size > 0 }
  end

  def parse_sections
    document.css("h2.strike-through").map do |header|
      build_section(header)
    end
  end

  def document
    Nokogiri::HTML(driver.page_source)
  end

  def build_section(header)
    {
      type: extract_section_type(header),
      cards: extract_cards(header)
    }
  end

  def extract_section_type(header)
    header.css("span").text
  end

  def extract_cards(header)
    header.parent.css("magic-card").map do |card|
      build_card(card)
    end
  end

  def build_card(card)
    {
      name: card["caption"],
      image: card["face"]
    }
  end

  def cleanup_driver
    driver&.quit
  end
end
