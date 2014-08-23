require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  # DeviceInfoの取得とパースと表示
  recv_pkt, data = initiator.data_operation(PTP_OC_GetDeviceInfo)
  dev_info = PTP_DeviceInfo.create(data)
  puts "Device Info :"
  puts "  #{dev_info.to_s }"

end

