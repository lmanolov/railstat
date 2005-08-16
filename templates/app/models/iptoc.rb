class Iptoc < ActiveRecord::Base
  def self.find_by_ip_address(ip_address)
    find (:first, :conditions => ["IP_FROM <= inet_aton('?') AND IP_TO >= inet_aton('?')", ip_address, ip_address])
  end
end
