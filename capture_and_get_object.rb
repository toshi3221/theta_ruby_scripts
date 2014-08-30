require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  # キャプチャ開始
  # [0,0]はストレージIDとキャプチャフォーマット
  # それぞれ0の時はデバイス側が判断する.
  initiator.operation :InitiateCapture, [0,0]
  print "Capturing...\n"

  # ObjectAddedイベントの待機
  response = initiator.wait_event
  added_object_handle = response[:parameters][0]

  # CaptureCompletedイベントの待機
  response = initiator.wait_event

  puts "GetObject..."
  response = initiator.operation :GetObject, [added_object_handle]
  File.open("./theta_pic.jpg", "wb") do |f|
    f.write(response[:data].pack("C*"))
    puts "Saved! Check './theta_pic.jpg'"
  end

end

