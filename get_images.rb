require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|
	t=Time.now
	date="#{t.year}-#{t.month}-#{t.day}-#{t.hour}#{t.min}#{t.sec}";
	Dir.mkdir("./HDR-#{date}")
	response = initiator.operation(:GetObjectHandles, [0xFFFFFFFF, 0xFFFFFFFF, 0])
  offset = 0
  @object_handles, offset = PTP_parse_long_array(offset, response[:data])
  p @object_handles

  print "GetObject...\n"
  response = initiator.operation(:GetObject, [@object_handles[-1]])
  File.open("./HDR-#{date}/theta_pic.jpg", "wb") do |f|
    f.write(response[:data].pack("C*"))
    print "Saved!\n"
  end
end