#! /usr/bin/env ruby
require 'erb'
require 'yaml'
require 'optparse'


options = {}

opts_parser = OptionParser.new do |opts|
    opts.banner="Usage: generate_nginx_config [options]"

    opts.on('-c','--config config_file','Usage config_file file') do |config_file|
        options[:config_file] = config_file
    end

    opts.on('-t','--template template_file','Usage template_file file') do |template_file|
        options[:template_file] = template_file
    end

    opts.on('-o','--output output_file','Write configuration to output_file') do |output_file|
        options[:output_file] = output_file
    end

    options[:overwrite] = nil
    opts.on('--overwrite','Overwrite output file configuration') do |overwrite|
        options[:overwrite] = true
    end

    opts.on('-h', '--help','Display this screen') do
        puts opts
        exit
    end
end

begin 
    opts_parser.parse!
    mandatory = [:config_file,:template_file]
    missing = mandatory.select{ |param| options[param].nil? }
    if not missing.empty?
        puts "Missing options: #{missing.join(', ')}"
        puts opts_parser
        exit
    end

rescue OptionParser::InvalidOption, OptionParser::MissingArgument
    puts $!.to_s
    puts opts_parser
    exit
end

puts "Performing task with options: #{options.inspect}" 

config = YAML.load(File.read(options[:config_file]))

if File.exists?(options[:output_file] || 'nginx.conf') && !options[:overwrite]
    puts "=> #{options[:output_file] || 'nginx.conf'} already exists, won't overwrite it.  Quitting."
    exit
else
    open('nginx.conf', 'w+').write(ERB.new(File.new(options[:template_file]).read,nil,'>').result(binding))
    puts "=> Wrote #{options[:output_file] || 'nginx.conf'} successfully."
end

