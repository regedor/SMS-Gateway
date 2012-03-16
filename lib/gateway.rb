#!/usr/bin/env ruby
#sms gateway script


class Gateway

  @@phones= Hash["359419001297612","voda","359419001303212","tmn","356479007544261","opti"]
  @@ports= ["ttyACM0","ttyACM1","ttyACM2"]
  

 # def detector(phone)
  #  res = %x[gammu-smsd-detect]
  #end

#loads phones that are connected, recreates config files
  def phoneloader
    @template = ''
    home = `echo ~`.chomp
    File.open("#{home}/.sms/gammu-smsdrc","r") do |f1|
      f1.each_line do |line|
        @template += line
      end
    end
    @@ports.each do |port|
      tmp = @template.gsub("%port",port)
      File.open("#{home}/.sms/gammu-smsdrc-#{port}","w") do |f2|
        f2.write(tmp)
      end
      imei = `gammu -c ~/.sms/gammu-smsdrc-#{port} --identify | grep IMEI`.split(/\s/).last

      if @@phones.keys.include?(imei)
        File.open("#{home}/.sms/gammu-smsdrc-#{@@phones[imei]}","w") do |f3|
          f3.write(tmp.gsub("%phone",@@phones[imei]))
        end
      end
      
    end
  end
  
  # kills gammu daemons, initiates new
  def start 
    #kill daemons
    if(`ps -A | grep gammu-smsd`)
      puts "Killing Daemons!"
      `killall gammu-smsd`
    end
    #reload daemons
      puts "Loading Daemons......"
      fork{ exec "gammu-smsd -c ~/.sms/gammu-smsdrc-voda &" }
      fork{ exec "gammu-smsd -c ~/.sms/gammu-smsdrc-tmn &" } 
      fork{ exec "gammu-smsd -c ~/.sms/gammu-smsdrc-opti &"}
  end

  #!deprecated! for testing purposes only, logic is already at dispatcher
  def send 
    opt = ARGV[0]
    number = ARGV[1]
    txt = ARGV[2]
    if opt == 'SEND'
      d = Dispatcher.new()
      phoneid= d.send(number,txt)
      if phoneid== ''
	puts "Sending failed"
      else 
        puts "Sending to: #{number}"
        puts "Text: #{txt}"
      end
    end
  end
end


# manages logs for each sent msg, number of sent sms in last daily/weekly batch
class Loggeri

  #counts number of sent sms by given device id,  in current day
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
  def leastcount
    
  end
  #writes new log entry for specific device with sent message and relevant data
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
    # validate number and check id, returns which operator/phoneid should send this message
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

#sends message to specified phone, if none specified identifies prefered phone
  def send( number, txt, user, p='')
       case p
         when ''
           l = Loggeri.new

           phone = self.checkphoneid( number )
           puts "DeviceID: #{phone} -auto mode"
           if l.write( user, phone, number, txt)
             `gammu-smsd-inject -c ~/.sms/gammu-smsdrc-#{phone} TEXT #{number} -text "#{txt}"` # send to daemon
             puts "Message Queued!"
           else 
             puts "sms quota full"
             
           end

         when /(^voda)|(^tmn)|(^opti)/
           phone = p
           puts "DeviceID: #{phone} -force mode"
           `gammu-smsd-inject -c ~/.sms/gammu-smsdrc-#{phone} TEXT #{number} -text "#{txt}"` # send to daemon
           puts "Message Queued!"
         else puts"Invalid Number"
         end
     return phone
  end
end
