#!/usr/bin/env ruby
#sms gateway script


class Gateway
  def start 
    #kill daemons
    if(`ps -A | grep gammu-smsd`)
      puts "Killing Daemons!"
      `sudo killall gammu-smsd`
    end
    #reload daemons
      puts "Loading Daemons......"
      `gammu-smsd -c ~/.sms/gammu-smsdrc-voda & sudo gammu-smsd -c ~/.sms/gammu-smsdrc-tmn & sudo gammu-smsd -c ~/.sms/gammu-smsdrc-opti &`
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
     qmanager=QuotaManager.new()
     if (qmanager.dailyQuota(phone)!=0)
       puts 1500-qmanager.dailyQuota(phone)
       qmanager.quotaUpdate(phone)
       `gammu-smsd-inject -c ~/.sms/gammu-smsdrc-#{phone} TEXT #{number} -text "#{txt}"` # send to daemon
       puts "Message Queued!"
     else 
       puts "Warning!! Daily quota reached, message batch saved for next work day."
       puts "No messages were sent."	
    
     end
  end
end

	
