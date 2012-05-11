require 'bundler/setup'

config = YAML::load(File.open(File.expand_path("../configuration.yml", __FILE__)))
MITE_ACCOUNT = config['mite']['account']
MITE_KEY     = config['mite']['key']