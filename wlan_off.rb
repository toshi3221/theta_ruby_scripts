require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  initiator.operation 'WlanPowerControl', [0,0,0,0,0]
  puts "Wlan OFF"

end

