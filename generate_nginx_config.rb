#! /usr/bin/env ruby
%w(erb yaml).each &method(:require)

def error(message) !puts(message) && exit end

env_in  = ENV['NGINX_CONFIG_YAML']
env_out = ENV['NGINX_CONFIG_FILE']

error "Usage: generate_nginx_config.rb [config file] [out file]" if ARGV.empty? && !env_in

config   = YAML.load_file(env_in || ARGV.shift || 'config.yml')
template = 'nginx.erb'

if File.exists? out_file = env_out || ARGV.shift || 'nginx.conf'
  error "=> #{out_file} already exists, won't overwrite it.  Quitting."
else
  open(out_file, 'w+').write(ERB.new(File.read(template), nil, '>').result(binding))
end
