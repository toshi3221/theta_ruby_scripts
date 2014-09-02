require './lib/theta_initiator.rb'

def get_device_prop_desc initiator, device_property_name
  puts "  #{device_property_name.to_s}[#{initiator.device_property_code(device_property_name).to_s(16)}]:"
  begin
    res = initiator.operation(:GetDevicePropDesc, [initiator.device_property_code(device_property_name)])
    desc = PTP_DevicePropDesc.create res[:data]
    puts "    #{desc.to_s}"
  rescue => e
    puts "    DevicePropNotSupported"
  end
end

ThetaInitiator.open do |i|

  puts "DevicePropDesc:"

  PtpCode::DEVICE_PROPERTIES.each do |code,name|
    next if name == 'Undefined'
    get_device_prop_desc i, name
  end
  
end
