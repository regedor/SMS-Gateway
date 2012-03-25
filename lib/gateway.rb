#!/usr/bin/env ruby
#sms gateway script

class Gateway
  def initialize(options)
    raise "Arg missing" unless @phones = options[:phones]
    raise "Arg missing" unless @ports  = options[:ports]
    phoneloader
    start
  end

  #loads phones that are connected, recreates config files
  def phoneloader
    template = IO.read( datafolder + "gammu-smsdrc")
    @ports.each do |port|
      IO.write (datafolder + port), template.gsub("%port",port)
      imei = `gammu -c #{datafolder + port} --identify | grep IMEI`.split(/\s/).last
      if @phones.keys.include?(imei)
        IO.write (datafolder + @phones[imei]), IO.read(datafolder + port).gsub("%phone",@phones[imei]) 
      end 
      system "rm #{datafolder + port}"
    end
  end
  
  # kills gammu daemons, initiates new
  def start 
    `killall gammu-smsd` && puts "Killing Daemons!" 
    puts "Loading Daemons......"
    @phone.values.each do |provider|
      fork{ exec "gammu-smsd -c #{datafoler+provider} &" }
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






