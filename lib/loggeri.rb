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