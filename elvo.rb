require 'mechanize'
require 'csv'
require 'rubygems'
require 'active_support/core_ext/numeric/time'

# e.g. ruby elvo.rb uk london 2018-09-02 2019-05-26
@country = ARGV[0] || "uk"
@city = ARGV[1] || "london"
@start_date = ARGV[2] || "2018-09-02"
@end_date = ARGV[3] || "2019-05-26"

def generate_dates
  parsed_start_date = Time.parse(@start_date)
  parsed_end_date = Time.parse(@end_date)

  CSV.open("output/ra.csv", "w") do |csv|
    csv << ["Date", "Event name", "Venue", "Lineup"]

    while parsed_start_date <= parsed_end_date
      # Format the date for RA
      current_month = parsed_start_date.strftime("%m")
      current_day = parsed_start_date.strftime("%d")
      formatted_date = "#{parsed_start_date.year}-#{current_month}-#{current_day}"
      
      puts "Checking listings for #{formatted_date}"

      # Add to the CSV
      scrape_resident_advisor_for(formatted_date).each do |data|
        csv << data.flatten!
      end

      # Now do next week
      parsed_start_date = parsed_start_date + 1.week
    end
  end
end

def scrape_resident_advisor_for(date)
  mechanize = Mechanize.new
  scraped_data = Hash.new

  page = mechanize.get("https://www.residentadvisor.net/events/#{@country}/#{@city}/week/#{date}")

  page.search('.event-item').each do |item|
    item_data = []
    item_data << item.search('.event-title a').first.text.strip # Event title
    item_data << item.search('.event-title span').text.strip.sub!("at ", "") # Venue name
    item_data << item.search('.event-lineup').text.strip # Lineup
    scraped_data[item.search('time').text.strip.sub!("T00:00", "")] = item_data
  end

  return scraped_data 
end

generate_dates