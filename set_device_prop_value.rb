require './lib/theta_initiator.rb'

ThetaInitiator.open do |i|

  res = i.operation(:GetDevicePropValue, [i.device_property_code(:WiteBalance)])
  puts "WhiteBalance: #{res[:data].pack('C*').unpack('S')[0]}"

  wb = 4
  res = i.operation(:SetDevicePropValue, [i.device_property_code(:WiteBalance)], [wb].pack('S').unpack('C*'))
  puts "Set WhiteBalance: #{wb.to_s}"

  res = i.operation(:GetDevicePropValue, [i.device_property_code(:WiteBalance)])
  puts "WhiteBalance: #{res[:data].pack('C*').unpack('S')[0]}"

end
