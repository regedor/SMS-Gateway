#!/usr/bin/env ruby
#sms gateway script


class Gateway
  def start 
    #kill daemons
    if(`ps -A | grep gammu-smsd`)
      puts "Killing Daemons!"
      `killall gammu-smsd`
    end
    #reload daemons
      puts "Loading Daemons......"
      `gammu-smsd -c ~/.sms/gammu-smsdrc-voda & gammu-smsd -c ~/.sms/gammu-smsdrc-tmn & gammu-smsd -c ~/.sms/gammu-smsdrc-opti &`
  end
 
  def send 
    opt = ARGV[0]
    number = ARGV[1]
    txt = ARGV[2]
    if opt == 'SEND'
      d = Dispatcher.new()
      d.send(number,txt)
      puts "Sending to: #{number}"
      puts "Text: #{txt}"
    end
  end
end


class Logger
  def smscount (phoneid)
    File.open("./log/log-#{phoneid}", "r") do |f1|
      if line = f1.gets
        while line = f1.gets
          linex = line
        end
        splitline = linex.split
        timenow = Time.now.inspect
        yymmdd = timenow.split[0]
        timelast = splitline[2]
        if timelast != yymmdd
          smscounter = 1
        else
          smscounter =  splitline[0].to_i + 1
        end
      else
        smscounter = 1
      end
      return smscounter
    end
  end
  
  def write ( user, phoneid , number , message)
    File.open("./log/log-#{phoneid}", "a") do |f1|
      @smscounter =  self.smscount(phoneid)
      timenow = Time.now.inspect
      if @smscounter < 1500
        f1.puts "---"
        f1.puts "PhoneId: #{phoneid}"
        f1.puts "User: #{user}"
        f1.puts "Phone: #{number}"
        f1.puts "Message: #{message}"        
        f1.puts "#{@smscounter} | #{timenow}"    
        return @smscounter
      else
        return false
      end
    end
  end
end



#sends 1 message to 1 number	
class Dispatcher
  def checkphoneid( number )
    # validate number and check id
    case number
      when /(((^\+)35191(.......))|(^91(.......)))/
        phone = "voda"
      when /(((^\+)35196(.......))|(^96(.......)))/
        phone = "tmn"
      when /(((^\+)35193(.......))|(^93(.......)))/
        phone = "opti"
      else 
        puts "Erro Numero: #{number}"
        return
    end
    return phone

  end

  def send( number, txt)
       phone = self.checkphoneid( number )
       puts "DeviceID: #{phone}"
     
       `gammu-smsd-inject -c ~/.sms/gammu-smsdrc-#{phone} TEXT #{number} -text "#{txt}"` # send to daemon
     puts "Message Queued!"
     return phone
  end
end

	
