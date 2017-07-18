require 'test_helper'

class JdPay::QrServiceTest < Minitest::Test
  def test_qrcode_pay
    response_body = <<-EOF
    <?xml version="1.0" encoding="UTF-8"?>
      <jdpay>
        <version>V2.0</version>
        <merchant>22294531</merchant>
        <result>
          <code>000000</code>
          <desc>成功</desc>
        </result>
        <encrypt>N2ZjNmIwMzJiMjA5ZTNhZDhjNjc0YmY1ZWJlY2QyODU0YTc5NmQ3ZWQxMWU1NzE3MWQ0OTUwOGI5NzllYmE4ZjM1YzRiZjlmYWE1M2ZiYjVjYTg5YjA4NTdhMjg3NTBhNzQxM2ZjOWFlN2U3YTNlYzM5ZTI5OTBkZDczNzQ5MjhjM2UxMjhkYWJhMGM0NWY2MWFjYjg2YWFlZDBjOTQ1Y2UyOWNlMDg2MmViOTQ3ZDUyZTczOTMxYjM0NGQwZTNjZGVjZTNkY2EwZmZlYzZlODE1Njc3YWMzODcyNTRhYTcyZDc5MjNhYzc5YWIzZGM0ZGIwYWE4NTc3ZTRhNmE3YmMxMjIwMmEyZmRjMDgxNjhlZjQ5ODVlNGIwNmU2ZTVjZjk3MWRlMmQ5NWYxMmJjNjFiOTY3M2E1ZGY0NWVkNmQ5NzU4OTFmNjFjNTMxMjQ0ZTUyZTdhOWZjNGYwYWRiNTM0ZTQyNGEzMWQyZTYyMWFkMWZkNWY2YTZkZDFmOWNkMTljODg2MzkxNmYwMWViNWMzM2JhNTM5ZWMxYjY1NTA2ZTdmMTYzMjY2YTVjZTk1OTE5M2U0NzNhMGNhMWIwMmVhZjdmYzUyYjc3ZDRiM2Y2NDVlNDFjMDI2YTM0YjU0MGE5MDQzZDEyYmRjNzQzYzM5ODc5NTRhMDcyNGFiOTI4NWQ3MmE0OWUwODNlNGZlNmM3OGMxNGJiNDAzMzI5YTVlMWViNjM2Y2ZkYTg5ZTc1ZDk2ZmJjNTcwMTIyYjU3NWUxZWI2MzZjZmRhODllNzFkYTM0NTE0MDM3YmU5ODQzZTI3Y2Y5OGFjYWM5ZGI3YTg4Yjk5YTQ5NjAxNWYyOWQxZjYwNTJmM2JhOWFlMWI0MzY2Yzc4MmY5YzJlNDY3ODljZjc3ZDMzYjVkN2IyZWRlZjcyOGQ0N2ViZDJkN2Y1YTA5ZTJiYTk5NjUxMGZjNmExMTA3OTFjMjY0NTMyODQ3YjRiYjc3MDlkMmY4YzllY2ZlNzE2MTE1ZjNkMzRlZGRhMmFhOGU4NTA0NThiZTdiOWUzYTM0MDczZTFjNzgxZDFkYzY1ZTRjYzRiYTY3ZGE4NzE4ZjJjNDBmMGU5ZDZlNWU2Y2RiNzAyMzUyNDIyZGVkYmU4NWM4MDdlZTVkNDhkZjg0NGMwNGUwMzA1ZWM5ODJkNmIwMWRmMzg3MjZjZGRkMTVhMWI4YjI1YTdhMWVmNTI2MDUzYmYzYzFlYTBmYmM2MTI3MDMwNTcyNTU1MzQyYjA0ZmZjN2NjOTg4Y2Q2YjQ1M2JhMDQ1NmE3ODUzNDMzMmNmNDFiNWI0M2M5ODhmNmNkMDI2MjFlZDIwYzRhYjliMjU2YmM3ZDU1Yzg2OTBkZWZjNTVhYjA1NzdiYzQxZmY0MzAxNmE3OTRlNWVkMjRjNDc4ZDgzN2JhNDZhMDAwY2ExOGMwMDQ4MWEwMmUyZTcyZjIwYTE0N2MyMTUwMWI3Mjg0NWE0ZDY3YTFiYTEyYzI2MTljYzhkMGM5YzJhOWU1NDljYmY0ZDJlYTM5M2IxYTg5ZWQ4NjMxZWM4NmIwNDI0YzJkYzBjNDU=</encrypt>
      </jdpay>
    EOF
    result = {"jdpay"=>{"version"=>"V2.0", "merchant"=>"22294531", "result"=>{"code"=>"000000", "desc"=>"成功"}, "orderId"=>"1029148637575787617463", "merchantName"=>"京东支付测试商户号", "amount"=>"1", "expireTime"=>"600", "tradeNum"=>"1486346954111", "qrCode"=>"https://h5pay.jd.com/code?c=616zlks7djfb1z", "sign"=>"C5Mn72q+w1ttkqsUSuhFwJjK8rpikxHkPHaJAXNBVvJGOLMYrSRkHTchACkAISiUzJ60ppWC4DnN6nfnbT5xyrK7kKmHuUivfGRGVnfucvZnV7eDS0Jv+7Np64P/ZyHUkesTDxb0+oDNilTaX82pV5Y2O0qmfs5Ft0LhpJ4Le/w="}}
    stub_request(:post, JdPay::Service::QRCODE_PAY_URL).to_return(body: response_body)
    params = {
      tradeNum: '123456780',
      tradeName: '测试商品',
      amount: '1',
      device: '0001',
      token: '2563256985478547856'
    }
    assert_equal result, JdPay::QrService.qrcode_pay(params)
  end
end
