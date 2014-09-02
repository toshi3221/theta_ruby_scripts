require './lib/theta_initiator.rb'

ThetaInitiator.open do |i|

  puts "DevicePropDesc:"

  res = i.operation(:GetDevicePropDesc, [i.device_property_code(:BatteryLevel),0,0])
  desc = PTP_DevicePropDesc.create res[:data]
  puts "  BatteryLevel:\n    #{desc.to_s}"

  res = i.operation(:GetDevicePropDesc, [i.device_property_code(:WhiteBalance),0,0])
  desc = PTP_DevicePropDesc.create res[:data]
  puts "  WhiteBalance:\n    #{desc.to_s}"

  res = i.operation(:GetDevicePropDesc, [i.device_property_code(:DateTime),0,0])
  desc = PTP_DevicePropDesc.create res[:data]
  puts "  DateTime:\n    #{desc.to_s}"

  begin
    i.operation(:GetDevicePropDesc, [i.device_property_code(:ExposureTime),0,0])
  rescue => e
    puts "  ExposureTime:\n    #{e.to_s}"
  end
  
  begin
    i.operation(:GetDevicePropDesc, [i.device_property_code(:ExposureProgramMode),0,0])
  rescue => e
    puts "  ExposureProgramMode:\n    #{e.to_s}"
  end
  
  res = i.operation(:GetDevicePropDesc, [i.device_property_code(:ExposureIndex),0,0])
  desc = PTP_DevicePropDesc.create res[:data]
  puts "  ExposureIndex:\n    #{desc.to_s}"
  
  res = i.operation(:GetDevicePropDesc, [i.device_property_code(:ExposureBiasCompensation),0,0])
  desc = PTP_DevicePropDesc.create res[:data]
  puts "  ExposureBiasCompensation:\n    #{desc.to_s}"

  res = i.operation(:GetDevicePropDesc, [i.device_property_code(:StillCaptureMode),0,0])
  desc = PTP_DevicePropDesc.create res[:data]
  puts "  StillCaptureMode:\n    #{desc.to_s}"
  
end
