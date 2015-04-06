require './lib/theta_initiator.rb'

ThetaInitiator.open do |i|

  [500,250,125,60,30,15].each do |shutter_speed|

    res = i.operation(:GetDevicePropValue, [i.device_property_code(:ExposureIndex)])
    puts "ExposureIndex: #{res[:data].pack('C*').unpack('S')[0]}"

    # ISOの設定
    i.operation(:SetDevicePropValue, [i.device_property_code(:ExposureIndex)], [100].pack('S').unpack('C*'))
    puts "Set ExposureIndex: 100"

    res = i.operation(:GetDevicePropValue, [i.device_property_code(:ExposureIndex)])
    puts "ExposureIndex: #{res[:data].pack('C*').unpack('S')[0]}"

    res = i.operation(:GetDevicePropValue, [i.device_property_code(:ShutterSpeed)])
    puts "ShutterSpeed: #{res[:data].pack('C*').unpack('LL').inspect}"

    # シャッタースピードの設定
    i.operation(:SetDevicePropValue, [i.device_property_code(:ShutterSpeed)], [1,shutter_speed].pack('L*').unpack('C*'))
    puts "Set ShutterSpeed: 1/#{shutter_speed}"

    res = i.operation(:GetDevicePropValue, [i.device_property_code(:ShutterSpeed)])
    puts "ShutterSpeed: #{res[:data].pack('C*').unpack('LL').inspect}"

    # 撮影
    i.operation 'InitiateCapture', [0,0]

    # ObjectAddedイベントの待機
    response = i.wait_event
    added_object_handle = response[:parameters][0]

    # CaptureCompletedイベントの待機
    response = i.wait_event

    # 画像の取得
    puts "GetObject..."
    File.open("./theta_pic_1_#{shutter_speed}.jpg", "wb") do |f|
      i.operation(:GetObject, [added_object_handle]) do |data|
        f.write data
      end
    end
    puts "Saved! Check './theta_pic_1_#{shutter_speed}.jpg'"

  end

end
