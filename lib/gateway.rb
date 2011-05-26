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

#check daily sms quota 
#!!RUDIMENTARY!! to be changed soon
class QuotaManager
  def dailyQuota ( phone )
    File.open("smscount-#{phone}", "r") do |f1|  
    line = f1.gets  
    smscount = Integer(line)

    return 1500-smscount
    end  
  end

  def quotaUpdate ( phone )
    # Create a new file and write to it  
    qman = QuotaManager.new()
    smscount = 1500-qman.dailyQuota(phone)
    smscount += 1
    File.open("smscount-#{phone}", "w") do |f2|  
    # use "\n" for two lines of text  
    f2.puts "#{smscount}"
    f2.close
    end 
  end
end

class Logger
  def smscount (phoneid)
    File.open("./log/log-#{phoneid}", "r") do |f1|
      line = f1.gets
      splitline = line.split
      timenow = Time.now.inspect
      yymmdd = timenow.split[0]
      timelast = splitline[2]
      if timelast = yymmdd
        smscounter = 1
      else
        smscounter =  splitline[0].to_i + 1
      end
      return smscounter
  end
  
  def write ( user, phoneid , number , message)
    File.open("./log/log-#{phoneid}", "rw") do |f1|
      smscounter =  self.smscount
      end
      if smscount < 1500
             f1.puts "---"
        f1.puts "Message: #{message}"
        f1.puts "Phone: #{number}"
        f1.puts "User: #{user}"
        f1.puts "PhoneId: #{phoneid}"
        f1.puts "#{smscount} | #{timenow}"    
        return smscount
      else
        return 0
      end
    end
  end
end


#sends 1 message to 1 number	
class Dispatcher
  def send ( number, txt)
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
     puts "DeviceID: #{phone}"
     
       `gammu-smsd-inject -c ~/.sms/gammu-smsdrc-#{phone} TEXT #{number} -text "#{txt}"` # send to daemon
     puts "Message Queued!"
     return phone
  end
end

	
