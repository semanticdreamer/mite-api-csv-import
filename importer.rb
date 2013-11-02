#!/usr/bin/env ruby

require "mite-rb"
require 'csv'
require 'date'

config = YAML.load_file('configuration.yml')

# check configuration
if config['mite']['account'].nil?
  raise RuntimeError, "Importer requires an MITE Account in the configuration.yml file."
end
if config['mite']['key'].nil?
  raise RuntimeError, "Importer requires an MITE Key in the configuration.yml file."
end
if !File.file?(config['csv']['file'])
  raise RuntimeError, "Importer requires a valid CSV file in the configuration.yml file."
end

puts "\n-------------------------------------------"
puts "          mite. API CSV Import            "
puts "-------------------------------------------\n"

# mite. authenticate
Mite.account = config['mite']['account']
Mite.key = config['mite']['key']

Mite.user_agent = "mite-api-csv-import/0.1.0;#{Mite.user_agent}"

if Mite.validate!
  
  puts " - import to account '#{Mite.account}'."

  row_count = 0
  customer_count = 0
  project_count = 0
  service_count = 0
  time_entry_count = 0
  
  CSV.foreach(config['csv']['file'], :headers => true) do |row|
    
    row_count += 1

    def time_to_minutes(time_str)
      hours, minutes = time_str.split(":").map{|str| str.to_i}
      hours * 60 + minutes
    rescue # no additional error handling here
      -1
    end
    minutes = time_to_minutes(row[config['csv']['columns']['minutes']])
    
    def hourlyrate_to_cent(hourlyrate_str)
      hourlyrate = hourlyrate_str.to_i
      hourlyrate * 100
    rescue # no additional error handling here
      -1
    end
    hourlyrate = hourlyrate_to_cent(row[config['csv']['columns']['hourlyrate']])
    
    def flag_to_boolean(flag_str)
      return true if flag_str =~ (/(true|t|yes|y|1)$/i)
      return false
    rescue # no additional error handling here
      -1
    end
    archived = flag_to_boolean(row[config['csv']['columns']['archived']])
    
    billable = flag_to_boolean(row[config['csv']['columns']['billable']])
    
    # do only consider a tracked time greater than 0 minutes
    if minutes > 0
      
      project = Mite::Project.first(
          :params => {:name => row[config['csv']['columns']['project']]}
        )
      if project.nil?
        customer = Mite::Customer.first(
            :params => {:name => row[config['csv']['columns']['customer']]}
          )
        if customer.nil? 
          customer = Mite::Customer.create(
            :name => row[config['csv']['columns']['customer']]
          )
          customer_count += 1
        end
        
        project = Mite::Project.create(
          :name => row[config['csv']['columns']['project']],
          :customer_id => customer.id,
          :hourly_rate => hourlyrate,
          :archived => archived
        )
        project_count += 1
      end
      
      service = Mite::Service.first(
          :params => {:name => row[config['csv']['columns']['service']]}
        )
      if service.nil? 
        service = Mite::Service.create(
          :name => row[config['csv']['columns']['service']],
          :billable => billable
        )
        service_count += 1
      end
      
      date_at = Date.strptime(row[config['csv']['columns']['date_at']], '%d.%m.%Y').strftime('%Y-%m-%d')
      
      note = row[config['csv']['columns']['note']]
    
      Mite::TimeEntry.create(
          :project_id => project.id, 
          :service_id => service.id,
          :date_at => date_at,
          :minutes => minutes,
          :note => note
        )
      time_entry_count += 1
      
    end # minutes > 0
    
  end # CSV.foreach

  puts " - #{row_count} rows processed."
  puts " - #{customer_count} customer(s) created."
  puts " - #{project_count} project(s) created."
  puts " - #{service_count} service(s) created."
  puts " - #{time_entry_count} time entries created."
  puts "-------------------------------------------"

end # Mite.valdiate!