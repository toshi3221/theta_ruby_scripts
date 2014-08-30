require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  # キャプチャ開始
  # [0,0]はストレージIDとキャプチャフォーマット
  # それぞれ0の時はデバイス側が判断する.
  puts "InitiateCapture call. transaction_id: #{initiator.next_transaction_id.to_s}"
  initiator.operation 'InitiateCapture', [0,0]

  print "Capturing...\r"

  # ObjectAddedイベントの待機
  response = initiator.wait_event :ObjectAdded  # 期待するevent_code指定は無ければチェックしない

  # CaptureCompleteイベントの待機
  response = initiator.wait_event 0x400D

end

