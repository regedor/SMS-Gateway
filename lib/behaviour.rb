module Behaviour
  # selects phone from given behaviour
  def self.select_phone(number, behaviour)
    self.send(behaviour['type'], number, behaviour['options'])
  end
  
  
 private
   
  def self.pt_single(number, options)
    if pt_checkphoneid(number) 
      a = Hash.new
      a = options['phones']
      if a.value?(options['phone'])
        options['phone']
      else
        "Invalid Phone in config"      
      end
    else
      nil
    end
  end

  def self.pt_default(number, options)
    pt_checkphoneid(number)
  end
  
  def self.check_limits(number , options)
    def_phone = pt_checkphoneid(number)
    count = options['phones'][def_phone][0..-1]
    timespan = options['phones'][def_phone].split('').last
  end
  # check number of sent items by day -> select Count(ID) from sentitems where DayOfYear(SendingDateTime) = DayOfYear(Now());

  # check number of sent items by week -> select Count(ID) from sentitems where  Week(SendingDateTime) = Week(Now()) AND Year(SendingDateTime) = Year(Now());

  # validate number and check id, returns which operator/phoneid should send this message
  def self.pt_checkphoneid( number )
    case number
      when /(((^\+)35191(.......)$)|(^91(.......)$))/
        phone = "vodafone"
      when /(((^\+)3519(6|2)(.......)$)|(^9(6|2)(.......)$))/
        phone = "tmn"
      when /(((^\+)35193(.......)$)|(^93(.......)$))/
        phone = "optimus"
      else 
        "Invalid Number"
    end
  end
  
end
