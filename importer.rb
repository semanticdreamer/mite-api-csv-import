#!/usr/bin/env ruby

require "bundler/setup"
require "mite-rb"

require File.expand_path('../helper.rb', __FILE__)

# Check configuration
if MITE_ACCOUNT.nil?
  raise RuntimeError, "Importer requires an MITE Account in the configuration.yml file."
end
if MITE_KEY.nil?
  raise RuntimeError, "Importer requires an MITE Key in the configuration.yml file."
end

Mite.account = MITE_ACCOUNT
Mite.key = MITE_KEY

Mite.user_agent = "mite-api-csv-import/0.1.0;#{Mite.user_agent}"

puts Mite.validate!