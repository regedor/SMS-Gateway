module Behaviour
  def self.select_phone(number, behaviour)
    self.send(behaviour['type'], number, behaviour['options'])
  end
  
  
 private
   
  def self.pt_single(number, options)
    if pt_checkphoneid(number)
      options['phone']
    else
      nil
    end
  end

  def self.pt_default(number, options)
    pt_checkphoneid(number)
  end
  
  
  # validate number and check id, returns which operator/phoneid should send this message
  def self.pt_checkphoneid( number )
    case number
      when /(((^\+)35191(.......))|(^91(.......)))/
        phone = "vodafone"
      when /(((^\+)3519(6|2)(.......))|(^9(6|2)(.......)))/
        phone = "tmn"
      when /(((^\+)35193(.......))|(^93(.......)))/
        phone = "optimus"
      else 
        nil
    end
  end
  
end
