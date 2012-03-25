class Behaviour
  def self.select_phone(number, behaviour)
    self.send(options['type'],number, behaviour['options'])
  end
  
  def self.pt-single(number, options)
    if pt-checkphoneid(number)
      options['phone']
    else
      nil
    end
  end

  def self.pt-default(number, options)
    pt-checkphoneid(number)
  end
  
  
 private
 
  # validate number and check id, returns which operator/phoneid should send this message
  def self.pt-checkphoneid( number )
    case number
      when /(((^\+)35191(.......))|(^91(.......)))/
        phone = "vodafone"
      when /(((^\+)35196(.......))|(^96(.......)))/
        phone = "tmn"
      when /(((^\+)35193(.......))|(^93(.......)))/
        phone = "optimus"
      else 
        nil
    end
  end
end