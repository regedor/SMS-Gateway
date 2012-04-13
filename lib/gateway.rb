#!/usr/bin/env ruby
#sms gateway script
require 'behaviour.rb'

class Gateway
  def initialize(config, options={:initialize_gammu => true})
    raise ArgumentError, "config should be an hash"          unless config.is_a? Hash
    raise ArgumentError, "options[:phones] is missing."      unless @phones      = config['phones']
    raise ArgumentError, "options[:ports] is missing."       unless @ports       = config['ports'].split(";")
    raise ArgumentError, "options[:datafolder] is missing."  unless @datafolder  = config['datafolder']
    unless options[:initialize_gammu] == false
      phoneloader
      start
    end
  end
  
  #loads phones that are connected, recreates config files
  def phoneloader
    raise IOError, "config file could not be read" unless template = IO.read( @datafolder + "gammu-smsdrc")
    @ports.each do |port|
      IO.write((@datafolder + port), template.gsub("%port",port))
      imei = `gammu -c #{@datafolder + port} --identify | grep IMEI")`.split(/\s/).last
      if @phones.keys.include?(imei)
        IO.write((@datafolder + @phones[imei]), IO.read(@datafolder + port).gsub("%phone",@phones[imei]))
      end 
      system "rm #{@datafolder + port}"
    end
  end
  
  # kills gammu daemons, initiates new
  def start 
    `killall gammu-smsd` && puts("Killing Daemons!")
    puts "Loading Daemons......"
    @phones.values.each do |provider|
      fork do
        exec "gammu-smsd -c #{@datafolder+provider} &"
      end
    end
  end
  
  #sends message to specified phone, if none specified identifies prefered phone
  def send(user, number, message, phone=nil)
    phone = Behaviour.select_phone(number, user['behaviour']) if phone.nil?
    if phone #se fizer match com os existentes
      `gammu-smsd-inject -c ~/.sms/gammu-smsdrc-#{phone} TEXT #{number} -text "#{message}"` # send to daemon
      #LOGIT que foi para a fila
    else 
      #LOGIT que alguem tentou mas nao foi para a fila
    end
  end
end

class IO
  def self.write(filepath, text)
    File.open(filepath, "w") { |f| f << text }
  end
end
