require './lib/theta_initiator.rb'
require 'FileUtils'
require 'open3'

ThetaInitiator.open do |initiator|

	current = Dir.pwd

	t = Time.now
	date = "#{t.year}-#{t.month}-#{t.day}-#{t.hour}#{t.min}#{t.sec}"
	FileUtils.mkdir_p("./outputs/HDR-#{date}")

	BRIGHTNESS = [-1300,0,1300]

	object_handles = Array.new(3)
	file_path = Array.new(3)   

	i = 0

	for value in BRIGHTNESS
		initiator.operation(:SetDevicePropValue, 
			[initiator.device_property_code(:ExposureBiasCompensation)],[value].pack('S').unpack('C*'))

		response = initiator.operation(:GetDevicePropValue,
			[initiator.device_property_code(:ExposureBiasCompensation)])
		puts "ExposureBiasCompensation: #{response[:data].pack('C*').unpack('s')[0].inspect}"

		
		initiator.operation :InitiateCapture, [0,0]
		response = initiator.wait_event #InitiateCaptureが終わるまで待機
		
		object_handles[i] = response[:parameters][0]
		initiator.wait_event #object_handles=respose[:parameters][0]が終わるまで待機
		
		i+=1
	end

	i=0

	for value in BRIGHTNESS
		a=0
		puts "GetObject...#{i+1}/3"
		file_path[i] = "/outputs/HDR-#{date}/theta_pic_#{value}.jpg"
		data_size = File.open(".#{file_path[i]}", "wb") do |f|
			response = initiator.operation(:GetObject, [object_handles[i]]) do |data|
				f.write data
			end
			puts "#{i+1}/3 Saved (data_size : #{response[:data_size]} byte)"
		end
		i+=1
	end

	#Open3.capture 出力抑制のため
	Open3.capture3 ("luminance-hdr-cli.exe --tmo mantiuk08 -o #{current}/outputs/HDR-#{date}/HDR.jpg #{current}#{file_path[1]} #{current}#{file_path[0]} #{current}#{file_path[2]}")
	Open3.capture3 ("luminance-hdr-cli.exe -o #{current}/outputs/HDR-#{date}/LDR.jpg #{current}#{file_path[1]} #{current}#{file_path[0]} #{current}#{file_path[2]}")

end