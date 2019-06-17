# Resident Advisor historic event scraper
A simple ruby script to parse the Resident Advisor site into a CSV.

### Usage
* `ruby elvo.rb {country} {city} {start-date} {end-date}`

| Parameter  	| Example value 	|
|------------	|---------------	|
|  country   	|  uk           	|
|  city      	|  london       	|
| start-date 	|  2018-8-25    	|
| end-date   	| 2018-9-25     	|

A file will be saved to `output/ra.csv`. If the command doesn't work, run `bundle install` and try again.