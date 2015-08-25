require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

	initiator.operation(:SetDevicePropValue, 
		[0x5010],[2000].pack('S').unpack('C*'))

	response = initiator.operation(:GetDevicePropValue,
		[0x5010])
    puts "ExposureBiasCompensation: #{response[:data].pack('C*').unpack('S').inspect}"

	response = initiator.operation :InitiateCapture, [0,0]
	response = initiator.wait_event

	initiator.operation(:SetDevicePropValue, 
		[0x5010],[0].pack('S').unpack('C*'))

	response = initiator.operation(:GetDevicePropValue,
		[0x5010])
    puts "ExposureBiasCompensation: #{response[:data].pack('C*').unpack('S').inspect}"

	response = initiator.operation :InitiateCapture, [0,0]
	response = initiator.wait_event

	initiator.operation(:SetDevicePropValue, 
		[0x5010],
		[-2000].pack('s').unpack('c*'))

	response = initiator.operation(:GetDevicePropValue,
		[initiator.device_property_code(:ExposureBiasCompensation)])
    puts "ExposureBiasCompensation: #{response[:data].pack('c*').unpack('s').inspect}"

	response = initiator.operation :InitiateCapture, [0,0]

end