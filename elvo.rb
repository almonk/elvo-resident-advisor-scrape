require 'mechanize'
require 'csv'
require 'rubygems'
require 'active_support/core_ext/numeric/time'

def generate_dates
  start_date = "2018-09-02"
  end_date = "2019-05-01"
  # end_date = "2018-09-18"
  
  start_time = Time.parse(start_date)
  end_time = Time.parse(end_date)

  CSV.open("output/ra.csv", "w") do |csv|
    csv << ["Date", "Event name", "Venue", "Lineup"]

    while start_time <= end_time
      # Format the date for RA
      current_month = start_time.strftime("%m")
      current_day = start_time.strftime("%d")
      formatted_date = "#{start_time.year}-#{current_month}-#{current_day}"
      
      puts "Checking listings for #{formatted_date}"

      # Add to the CSV
      scrape_resident_advisor_for(formatted_date).each do |data|
        csv << data.flatten!
      end

      # Now do next week
      start_time = start_time + 1.week
    end
  end
end

def scrape_resident_advisor_for(date)
  mechanize = Mechanize.new
  scraped_data = Hash.new

  page = mechanize.get('https://www.residentadvisor.net/events/tk/istanbul/week/' + date)

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