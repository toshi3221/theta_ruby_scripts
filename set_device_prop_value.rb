require './lib/theta_initiator.rb'

ThetaInitiator.open do |i|

  res = i.operation(:GetDevicePropValue, [i.device_property_code(:WhiteBalance)])
  original_white_balance = res[:data].pack('C*').unpack('S')[0]
  puts "WhiteBalance: #{original_white_balance.to_s}"

  wb = i.white_balance_code :Daylight
  res = i.operation(:SetDevicePropValue, [i.device_property_code(:WhiteBalance)], [wb].pack('S').unpack('C*'))
  puts "Set WhiteBalance: #{wb.to_s}"

  res = i.operation(:GetDevicePropValue, [i.device_property_code(:WhiteBalance)])
  puts "WhiteBalance: #{res[:data].pack('C*').unpack('S')[0]}"

  i.operation(:SetDevicePropValue, [i.device_property_code(:WhiteBalance)], [original_white_balance].pack('S').unpack('C*'))

end
