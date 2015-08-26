require './lib/theta_initiator.rb'
require 'FileUtils'


ThetaInitiator.open do |initiator|
	Current = Dir.pwd

	t = Time.now
	date = "#{t.year}-#{t.month}-#{t.day}-#{t.hour}#{t.min}#{t.sec}"
	FileUtils.mkdir_p("./outputs/HDR-#{date}")

	BRIGHTNESS = [-2000,0,2000]

	object_handles = Array.new(3)
	file_path = Array.new(3)   

	i = 0

	for value in BRIGHTNESS
		initiator.operation(:SetDevicePropValue, 
			[0x5010],[value].pack('S').unpack('C*'))

		response = initiator.operation(:GetDevicePropValue,
			[0x5010])
		puts "ExposureBiasCompensation: #{response[:data].pack('C*').unpack('s')[0].inspect}"

		initiator.operation :InitiateCapture, [0,0]
		response = initiator.wait_event #イベントが終わるまで待機
		object_handles[i] = response[:parameters][0]

		initiator.wait_event #イベントが終わるまで待機
		i+=1
	end

	i=0

	for value in BRIGHTNESS
		puts "GetObject...#{i+1}/3"
		response = initiator.operation(:GetObject, [object_handles[i]])
		File.open("./outputs/HDR-#{date}/theta_pic_#{value}.jpg", "wb") do |f|
			f.write(response[:data].pack("C*"))
			puts "#{i+1}/3 Saved!"
			file_path[i] = "/outputs/HDR-#{date}/theta_pic_#{value}.jpg"
		end
		i+=1
	end

	system "luminance-hdr-cli.exe -o #{Current}/outputs/HDR-#{date}/HDR.jpg #{Current}#{file_path[0]} #{Current}#{file_path[1]} #{Current}#{file_path[2]}"
end