# lib/tasks/import_cards.rake
namespace :cards do
  desc "Import magic cards from the gallery"
  task import: :environment do
    puts "Starting card import..."
    CardImportService.call
    puts "Import completed!"
  rescue StandardError => e
    puts "Import failed: #{e.message}"
    raise e
  end
end
