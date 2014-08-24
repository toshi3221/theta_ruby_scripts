require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  # DeviceInfoの取得とパースと表示
  response = initiator.operation(:GetDeviceInfo)
  dev_info = PTP_DeviceInfo.create(response[:data])
  puts "Device Info :"
  puts "  #{dev_info.to_s}"

end

