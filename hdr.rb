require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

	t=Time.now
	date="#{t.year}-#{t.month}-#{t.day}-#{t.hour}#{t.min}#{t.sec}";
	Dir.mkdir("./HDR-#{date}")

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

	response = initiator.operation(:GetObjectHandles, [0xFFFFFFFF, 0xFFFFFFFF, 0])
	offset = 0
	@object_handles, offset = PTP_parse_long_array(offset, response[:data])
	p @object_handles

	i=1

	for value in Brightness
		print "GetObject...#{i}/3\n"
		response = initiator.operation(:GetObject, [@object_handles[-4+i]])
		File.open("./HDR-#{date}/theta_pic-#{value}.jpg", "wb") do |f|
			f.write(response[:data].pack("C*"))
			print "#{i}/3 Saved!\n"
		end
		i+=1

	end
end