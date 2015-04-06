require_relative '../ruby_ptp_ip/ptp_ip_initiator.rb'

#operation code
PTP_OC_WlanPowerControl = PTP_OC_THETA_WlanPowerControl = 0x99A1

create_ptp_code_hash(/^PTP_OC_THETA_/).map do |code,name|
  PtpCode::OPERATION_RESPONSES[code] = name
end

#device prop code(RICOH THETA Extension)
PTP_DPC_ErrorInfo = PTP_DPC_THETA_ErrorInfo = 0xD006
PTP_DPC_ShutterSpeed = PTP_DPC_THETA_ShutterSpeed = 0xD00F
PTP_DPC_GpsInfo = PTP_DPC_THETA_GpsInfo = 0xD801
PTP_DPC_AutoPowerOffDelay = PTP_DPC_THETA_AutoPowerOffDelay = 0xD802 
PTP_DPC_SleepDelay = PTP_DPC_THETA_SleepDelay = 0xD803
PTP_DPC_ChannelNumber = PTP_DPC_THETA_ChannelNumber = 0xD807
PTP_DPC_CaptureStatus = PTP_DPC_THETA_CaptureStatus = 0xD808
PTP_DPC_RecordingTime = PTP_DPC_THETA_RecordingTime = 0xD809
PTP_DPC_RemainingRecordingTime = PTP_DPC_THETA_RemainingRecordingTime = 0xD80A

create_ptp_code_hash(/^PTP_DPC_THETA_/).map do |code,name|
  PtpCode::DEVICE_PROPERTIES[code] = name
end

class ThetaInitiator

  # THETAのIPアドレスとPTP-IPのポート番号
  ADDR = "192.168.1.1"
  PORT = 15740

  # THETAに送るレスポンダ情報
  NAME = "RUBY_THETA_INITIATOR"
  GUID = "ab653fb8-4add-44f0-980e-939b5f6ea266"
  PROTOCOL_VERSION = 65536

  def self.open
    initiator = PtpIpInitiator.new ADDR, PORT, GUID, NAME, PROTOCOL_VERSION
    if block_given?
      initiator.open do |initiator|
        yield initiator
      end
    else
      return initiator.open
    end
  end

end

