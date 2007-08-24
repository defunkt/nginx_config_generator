#! /usr/bin/env ruby
%w(erb yaml).each &method(:require)

def error(message) puts(message) || exit end
def file(file) "#{File.dirname(__FILE__)}/#{file}" end

if ARGV.include? '--example'
  example = file:'config.yml.example'
  error open(example).read 
end

env_in  = ENV['NGINX_CONFIG_YAML']
env_out = ENV['NGINX_CONFIG_FILE']

error "Usage: generate_nginx_config [config file] [out file]" if ARGV.empty? && !env_in

overwrite = %w(-y -o -f --force --overwrite).any? { |f| ARGV.delete(f) }

config   = YAML.load_file(ERB.new(env_in || ARGV.shift || 'config.yml').result)
template = file:'nginx.erb'

if File.exists?(out_file = env_out || ARGV.shift || 'nginx.conf') && !overwrite
  error "=> #{out_file} already exists, won't overwrite it.  Quitting."
else
  open(out_file, 'w+').write(ERB.new(File.read(template), nil, '>').result(binding))
  error "=> Wrote #{out_file} successfully."
end
