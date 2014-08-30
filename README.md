## 概要

RICOH THETAをWifiで接続して操作するRubyイニシエータとスクリプトサンプル。
スクリプトファイルを作成して実行、またはirb/pryよりインタプリタにて実行可能です。

## リポジトリの準備

ruby_ptp_ipリポジトリをsubmoduleとして持っているので、新規にリポジトリを取得する場合、

```
git clone --recursive git@github.com:toshi3221/theta_ruby_scripts.git
```

既にリポジトリが存在しているがsubmodleを取得していない場合は

```
git submodule update --init --recursive
```

にてruby_ptp_ipも取得しておいてください

## 使い方

### RICOH THETAとの接続

事前にRICOH THETA本体とWifiを接続しておきます。

```ruby
require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  # イニシエータ操作を記述

end
```

または

```ruby
require './lib/theta_initiator.rb'

initiator = ThetaInitiator.open
```

にてイニシエータをオープン(コマンド接続、イベント接続を行い、OpenSessionコマンドを完了)します。
PTPコマンドの送信とイベント受信が可能な状態になります。

ブロック定義しないインタプリタ形式で実行する場合は操作終了時クローズも行ってください

```ruby
initiator.close
```

### イニシエータ操作

ThetaInitiator.openによって受け取ったinitiatorオブジェクトによって各種操作が行えます。

#### operation

```ruby
initiator.operation command_code_name, parameters, data
```

PTP operation定義のコマンド名とparametersを指定します。コマンド名は、Symbol、parametersはArrayで指定してください。
SetDevicePropValue等のデータフェーズがあるコマンドの場合はdataをunpack('C*')の形式で指定して下さい。

##### ex.

```ruby
response = initiator.operation :InitiateCapture, [0,0]
response = initiator.operation :SetDevicePropValue,
             [initiator.device_property_code(:WhiteBalance)],
             [initiator.white_balance_code(:Daylight)].pack('S').unpack('C*')
```

```
response:
  :code           : PTP operationレスポンスコード
  :parameters     : PTP operationレスポンスパラメータ。Arrayで返ります
  :transaction_id : operation要求したtransaction_id
  :data           : 指定したoperationにデータフェースが入る場合にバイナリ分割された1バイト単位のArrayリストで返ります。
                    たとえば32bit_INTが格納されている場合は、data.pack('C*').unpack('L')のようにデシリアライズします。
```

#### event

```ruby
initiator.wait_event expected_event_code_name
initiator.get_event expected_event_code_name
initiator.has_event?
```

wait_eventメソッドにてイベントの同期待ちに対応しています。expected_event_code_nameは期待するevent_codeを指定して異なるものを受信した場合は例外を返します。
省略することも可能です。

イベント待ちでスレッドをブロックされたくない場合はhas_event?メソッドにてイベントがあるか事前に確認するか、get_eventメソッドを利用して下さい。get_eventはイベント受信がない場合nilを返します。

ex.

```ruby
initiator.wait_event :ObjectAdded
initiator.wait_event
```

```
response:
  :event_code     : PTP eventコード
  :parameters     : PTP eventパラメータ。Arrayで返ります
  :transaction_id : event発生のきっかけとなったtransaction_id
```

#### コード名からのコード変換

operation、event等、コード名称からコードに変換するいくつかのメソッドを用意しています(コード定数定義はruby_ptp_ip/ptp.rb)。
パラメータ指定時に利用できる場合は使ってください。

```ruby

# Event Code Hash: code => event_name
PtpCode::EVENTS
# event_code :ObjectAdded => PTP_EC_ObjectAdded(0x4002)
initiator.event_code :ObjectAdded
# event_name 0x4002 => "ObjectAdded"
initiator.event_name 0x4002

# Operation Code Hash: code => operation_name
PtpCode::OPERATIONS
# operation_code :InitiateCapture => PTP_OC_InitiateCapture(0x100E)
initiator.operation_code :InitiateCapture
# operation_code 0x100E => "InitiateCapture"
initiator.operation_name 0x100E

# Operation Response Code Hash: code => operation_response_name
PtpCode::OPERATION_RESPONSES
# operation_response_code :OK => (0x2001)
initiator.operation_response_code :OK
# operation_response_name 0x2001 => "OK"
initiator.operation_response_name 0x2001

# Device Property Hash: code => device_property_name
PtpCode::DEVICE_PROPERTIES
# device_property_code :BatteryLevel => PTP_DPC_BatteryLevel(0x5001)
initiator.device_property_code :BatteryLevel
# device_property_name 0x5001 => "BatteryLevel"
initiator.device_property_name 0x5001

# Object Format Hash: code => object_format_name
PtpCode::OBJECT_FORMATS
# object_format_code :EXIF_JPEG => PTP_OFC_EXIF_JPEG(0x3801)
initiator.object_format_code :EXIF_JPEG
# object_format_name 0x3801 => "EXIF_JPEG"
initiator.object_format_name 0x3801

# White Balance Hash: code => white_balance_name
PtpCode::WHITE_BALANCES
# white_balance_code :Daylight => PTP_WB_Daylight(0x0004)
initiator.white_balance_code :Daylight
# white_balance_name 0x0004 => 'Daylight'
initiator.white_balance_name 0x0004

```
