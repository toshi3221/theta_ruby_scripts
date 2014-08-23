require_relative '../ruby_ptp_ip/ptp.rb'
require_relative '../ruby_ptp_ip/ptp_ip.rb'
require_relative '../ruby_ptp_ip/ptp_ip_initiator.rb'

class ThetaInitiator

  # THETAのIPアドレスとPTP-IPのポート番号
  ADDR = "192.168.1.1"
  PORT = 15740

  # THETAに送るレスポンダ情報
  NAME = "RUBY_THETA_INITIATOR"
  GUID = "ab653fb8-4add-44f0-980e-939b5f6ea266"
  PROTOCOL_VERSION = 65536

  def self.open
    initiator = PtpIpInitiator.new ADDR, PORT, GUID, NAME, PROTOCOL_VERSION
    if block_given?
      initiator.open do |initiator|
        yield initiator
      end
    else
      return initiator.open
    end
  end

end

