require_relative "../config/environment"
#created the database & table
#created the database & table
DB = SQLite3::Database.new "companies.db"
Company.create_table

jobScraper = Scraper.new
jobScraper.scrapeJobs.each do |company|
  company.save
  puts "#{company.companyName} is hiring at #{company.jobURL}"
end
