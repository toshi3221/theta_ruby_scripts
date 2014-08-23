require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  # キャプチャ開始
  # [0,0]はストレージIDとキャプチャフォーマット
  # それぞれ0の時はデバイス側が判断する.
  initiator.simple_operation(PTP_OC_InitiateCapture, [0,0])
  print "Capturing...\n"

  # ObjectAddedイベントの待機
  recv_pkt = initiator.wait_event
  added_object_handle = recv_pkt.payload.parameters[0]
  print "Object Added!\n  Event: #{recv_pkt.payload.to_hash.inspect}\n"

  # CaptureCompletedイベントの待機
  recv_pkt = initiator.wait_event
  print "Capture Completed!\n  Event: #{recv_pkt.payload.to_hash.inspect}\n"

  puts "GetObject..."
  recv_pkt, data = initiator.data_operation(PTP_OC_GetObject, [added_object_handle])
  File.open("./theta_pic.jpg", "wb") do |f|
    f.write(data.pack("C*"))
    puts "Saved! Check './theta_pic.jpg'"
  end

end

