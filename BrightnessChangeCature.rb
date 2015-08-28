require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

	Brightness = [-2000,0,2000]

	for value in Brightness
		initiator.operation(:SetDevicePropValue, 
		[0x5010],[value].pack('S').unpack('C*'))

		response = initiator.operation(:GetDevicePropValue,
			[0x5010])
	    puts "ExposureBiasCompensation: #{response[:data].pack('C*').unpack('S').inspect}"

		response = initiator.operation :InitiateCapture, [0,0]
		response = initiator.wait_event
	    added_object_handle = response[:parameters][0]

		response = initiator.wait_event
	end
end