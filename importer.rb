#!/usr/bin/env ruby

# suppress warnings
$VERBOSE = nil

require "mite-rb"
require 'csv'
require 'date'

require "net_http_ssl_fix"

# current directory
pwd = __dir__

# ocra ruby env?
ocra_exe = ENV['OCRA_EXECUTABLE'] || ''
if !ocra_exe.empty?
  pwd = ocra_exe.sub('\\importer.exe', '')
end

config = YAML::load_file(File.join(pwd, 'config.yml'))

# check configuration
if config['mite']['account'].nil?
  raise RuntimeError, "Importer requires an MITE Account in the config.yml file."
end
if config['mite']['key'].nil?
  raise RuntimeError, "Importer requires an MITE Key in the config.yml file."
end
if !File.file?(config['csv']['file'])
  raise RuntimeError, "Importer requires a valid CSV file in the config.yml file."
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
          :customer_id => customer.id
        )
        project_count += 1
      end
      
      service = Mite::Service.first(
          :params => {:name => row[config['csv']['columns']['service']]}
        )
      if service.nil? 
        service = Mite::Service.create(
          :name => row[config['csv']['columns']['service']]
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
