require './lib/theta_initiator.rb'

ThetaInitiator.new.open do |initiator|

  # DeviceInfoの取得とパースと表示
  recv_pkt, data = initiator.data_operation(PTP_OC_GetDeviceInfo)
  dev_info = PTP_DeviceInfo.create(data)
  print "Device Info :\n"
  p dev_info.to_s

  # キャプチャ開始
  # [0,0]はストレージIDとキャプチャフォーマット
  # それぞれ0の時はデバイス側が判断する.
  puts "InitiateCapture call. transaction_id: #{initiator.transaction_id.to_s}"
  initiator.simple_operation(PTP_OC_InitiateCapture, [0,0])

  print "Capturing...\r"

  # ObjectAddedイベントの待機
  recv_pkt = initiator.wait_event
  raise "Invalid Event Code" unless recv_pkt.payload.event_code == PTP_EC_ObjectAdded

  print "Object Added!\n  Event: #{recv_pkt.payload.to_hash.inspect}\n"

  # CaptureCompletedイベントの待機
  recv_pkt = initiator.wait_event
  raise "Invalid Event Code" unless recv_pkt.payload.event_code == PTP_EC_CaptureComplete

  print "Capture Completed!\n  Event: #{recv_pkt.payload.to_hash.inspect}\n"

end

