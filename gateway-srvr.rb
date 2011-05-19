#!/usr/bin/env ruby
#sms gateway daemon loader

#ARGV.each do|a|
# puts "Argument: #{a}"
#end

#rudimentary sms counter & resetter
currdate = Integer(`date +"%H"`)
if((currdate<2)&&(currdate>=1))
  puts "Updating SmS Quotas.."
  
  File.open("smscount-voda", "w") do |f2|
  # use "\n" for two lines of text  
  f2.puts "0"
  end
  File.open("smscount-tmn", "w") do |f2|
  # use "\n" for two lines of text  
  f2.puts "0"
  end
  File.open("smscount-opti", "w") do |f2|
  # use "\n" for two lines of text  
  f2.puts "0"
  end


end

#kill daemons
if(`ps -A | grep gammu-smsd`)
	puts "Killing Daemons!"
	`sudo killall gammu-smsd`
end
#reload daemons
puts "Loading Daemons......"
`gammu-smsd -c ~/.sms/gammu-smsdrc-voda & sudo gammu-smsd -c ~/.sms/gammu-smsdrc-tmn & sudo gammu-smsd -c ~/.sms/gammu-smsdrc-opti &`
#`sudo gammu-smsd -c /etc/gammu-smsdrc-voda & sudo gammu-smsd -c /etc/gammu-smsdrc-tmn & sudo gammu-smsd -c /etc/gammu-smsdrc-opti &`
puts "Done."

