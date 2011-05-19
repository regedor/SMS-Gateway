#!/usr/bin/env ruby
#sms gateway script
#gateway.rb "number" "message"

#ARGV.each do|a|
# puts "Argument: #{a}"
#end

number = ARGV.first
txt = ARGV.last
puts "Sending to: #{number}"
puts "Text: #{txt}"

#`sudo cat #{txt} | /usr/bin/gammu --sendsms TEXT #{number}`

#check daily sms quota
class QuotaManager
  def dailyQuota ( phone )
    File.open("smscount-#{phone}", "r") do |f1|  
    line = f1.gets  
    smscount = Integer(line)
     
  
    #smscount = line #`cat smscount-#{phone}`
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
#    smscount = `cat smscount-#{phone}`
 #   smscount = 1400 #smscount+1 # increase

#    `rm smscount-#{phone}` # updt
#    `echo #{smscount} >> smscount-#{phone}` # updt

  end
end

class Aggregator
  def queue ( number, txt) 
			
  end
end
	
class Dispatcher
  def send ( number, txt)
#    `sudo echo "sms test" | /usr/bin/gammu --sendsms TEXT +351912927471`
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
       #`sudo gammu-smsd-inject -c /etc/gammu-smsdrc-#{phone} TEXT #{number} -text "#{txt}"`
       puts "Message Queued!"
     else 
       puts "Warning!! Daily quota reached, message batch saved for next work day."
       puts "No messages were sent."	
    
     end
  end
end

 
d = Dispatcher.new()

d.send(number,txt)

