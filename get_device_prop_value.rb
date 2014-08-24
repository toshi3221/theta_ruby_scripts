require './lib/theta_initiator.rb'

ThetaInitiator.open do |i|

  res = i.operation(:GetDevicePropValue, [i.device_property_code(:BatteryLevel),0,0])
  puts "BatteryLevel: #{res[:data][0].to_s}"

end
