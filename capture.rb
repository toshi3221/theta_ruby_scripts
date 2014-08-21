require './ruby_ptp_ip/ptp.rb'
require './ruby_ptp_ip/ptp_ip.rb'
require './ruby_ptp_ip/ptp_ip_initiator.rb'

# THETAのIPアドレスとPTP-IPのポート番号
ADDR = "192.168.1.1"
PORT = 15740

# THETAに送るレスポンダ情報
NAME = "Ruby_THETA_Shutter"
GUID = "ab653fb8-4add-44f0-980e-939b5f6ea266"
PROTOCOL_VERSION = 65536

PtpIpInitiator.new(ADDR, PORT, GUID, NAME, PROTOCOL_VERSION).open do |initiator|

  # DeviceInfoの取得とパースと表示
  recv_pkt, data = initiator.data_operation(PTP_OC_GetDeviceInfo)
  dev_info = PTP_DeviceInfo.create(data)
  print "Device Info :\n"
  p dev_info.to_s

  # キャプチャ開始
  # [0,0]はストレージIDとキャプチャフォーマット
  # それぞれ0の時はデバイス側が判断する.
  initiator.simple_operation(PTP_OC_InitiateCapture, [0,0])

  print "Capturing...\r"

  # ObjectAddedイベントの待機
  recv_pkt = initiator.wait_event
  raise "Invalid Event Code" unless recv_pkt.payload.event_code == PTP_EC_ObjectAdded

  print "Object Added!\n"

  # CaptureCompletedイベントの待機
  recv_pkt = initiator.wait_event
  raise "Invalid Event Code" unless recv_pkt.payload.event_code == PTP_EC_CaptureComplete

  print "Capture Completed!\n"

end

