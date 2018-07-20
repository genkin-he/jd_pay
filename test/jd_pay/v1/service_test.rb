require 'test_helper'

class JdPay::ServiceTest < Minitest::Test
  def setup
    @response_body = <<-EOF
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
    @result = {"jdpay"=>{"version"=>"V2.0", "merchant"=>"22294531", "result"=>{"code"=>"000000", "desc"=>"成功"}, "orderId"=>"1029148637575787617463", "merchantName"=>"京东支付测试商户号", "amount"=>"1", "expireTime"=>"600", "tradeNum"=>"1486346954111", "qrCode"=>"https://h5pay.jd.com/code?c=616zlks7djfb1z", "sign"=>"C5Mn72q+w1ttkqsUSuhFwJjK8rpikxHkPHaJAXNBVvJGOLMYrSRkHTchACkAISiUzJ60ppWC4DnN6nfnbT5xyrK7kKmHuUivfGRGVnfucvZnV7eDS0Jv+7Np64P/ZyHUkesTDxb0+oDNilTaX82pV5Y2O0qmfs5Ft0LhpJ4Le/w="}}
  end

  def test_pc_pay
    stub_request(:post, JdPay::Service::V1::PC_PAY_URL).with(headers:  {'Content-Type' => 'application/x-www-form-urlencoded'}, body: {
      version: 'V2.0',
      merchant: '22294531',
      tradeTime: 'd9668085c69c2ecb73421627b78590400135be4ad908a2a7',
      currency: 'ac7132c57f10d3ce',
      tradeNum: 'b9a9953b73f9f8eb3612d06b873f74e9',
      tradeName: '25fc4ff3e72f364fc1d80691e88fd7df',
      amount: 'e5a6c3761ab9ddaf',
      orderType: 'e00c693e6c5b8a60',
      notifyUrl: 'd54a8a984359284ec3d58d814e65630300d528555ef1e14ebe9ff87c62d78770',
      callbackUrl: 'b470f968b7165dcf745e8e129f073434ef9ec43bd64dda9ba2fe77001f4c7347',
      userId: '29d899fc35dc7aa50640156c06e5ec0f',
      sign: 'di/QyXcBJGY/Avb8ilTEUsCxto6F5fbjX4mvGt0a0J2XD1dTJ8sPidfTHofagsgz9H/CP3FC6Hqca49woS7o8vkn4oPfA+coHfxBnm4QtBcvdeQjW3fKq2IKbtGG7UGNGXEJc9Gk7BnXNnuvnbEc5FVFcvbqirdNi+7opO9jmaM='
    }).to_return(headers: {'Location' => 'payCashier?tradeNum=12345678&ourTradeNum=1234567890&key=fookey'}, status: 302)

    params = {
      tradeNum: '12345678',
      tradeName: '测试商品',
      amount: '1',
      orderType: '0',
      notifyUrl: 'http://making.dev/notify',
      callbackUrl: 'http://frontend.com/return',
      userId: "0000001",
      tradeTime: '20170718101010'
    }
    assert_equal 'https://wepay.jd.com/jdpay/payCashier?tradeNum=12345678&ourTradeNum=1234567890&key=fookey', JdPay::Service::V1.pc_pay(params)
  end

  def test_h5_pay
    stub_request(:post, JdPay::Service::V1::H5_PAY_URL).with(headers:  {'Content-Type' => 'application/x-www-form-urlencoded'}, body: {
      version: 'V2.0',
      merchant: '22294531',
      tradeTime: 'd9668085c69c2ecb73421627b78590400135be4ad908a2a7',
      currency: 'ac7132c57f10d3ce',
      tradeNum: 'b9a9953b73f9f8eb3612d06b873f74e9',
      tradeName: '25fc4ff3e72f364fc1d80691e88fd7df',
      amount: 'e5a6c3761ab9ddaf',
      orderType: 'e00c693e6c5b8a60',
      notifyUrl: 'd54a8a984359284ec3d58d814e65630300d528555ef1e14ebe9ff87c62d78770',
      callbackUrl: 'b470f968b7165dcf745e8e129f073434ef9ec43bd64dda9ba2fe77001f4c7347',
      userId: '29d899fc35dc7aa50640156c06e5ec0f',
      sign: 'di/QyXcBJGY/Avb8ilTEUsCxto6F5fbjX4mvGt0a0J2XD1dTJ8sPidfTHofagsgz9H/CP3FC6Hqca49woS7o8vkn4oPfA+coHfxBnm4QtBcvdeQjW3fKq2IKbtGG7UGNGXEJc9Gk7BnXNnuvnbEc5FVFcvbqirdNi+7opO9jmaM='
    }).to_return(headers: {'Location' => 'payCashier?tradeNum=12345678&ourTradeNum=1234567890&key=fookey'}, status: 302)


    params = {
      tradeNum: '12345678',
      tradeName: '测试商品',
      amount: '1',
      orderType: '0',
      notifyUrl: 'http://making.dev/notify',
      callbackUrl: 'http://frontend.com/return',
      userId: "0000001",
      tradeTime: '20170718101010'
    }
    assert_equal 'https://h5pay.jd.com/jdpay/payCashier?tradeNum=12345678&ourTradeNum=1234567890&key=fookey', JdPay::Service::V1.h5_pay(params)
  end

  def test_verify_redirection
    # invalid param
    foo_params = {
      'amount' => '216d686c8900e730',
      'currency' => 'f42451d04fdb7b06',
      'note' => '',
      'sign' => 'hO5dwBI6P9jpcPComYNzXct5P5Y2yHI4awojnp1xh1AaJseqegga5VsTV9GMlypXio8wK4PztvvP
 U4z14YMka0PDVkzuaA9LV7nPwbQQPj+0tT1F7kiVLIhk//Er2XtzNH93CwReKY9YZEP9NIsgaLTb
 dK6JAdQiOQyz6CN7dDY=',
      'status' => 'f60d28559734b3a0',
      'tradeNum' => '8deb6f6eb7daed9119c6088b63f8eb3986f651ad81f83ba5',
      'tradeTime' => 'cdf7da29ab4ff16833fcd7d819ef300774d016b035035df2'
    }

    begin
      decrypted_param = JdPay::Service::V1.verify_redirection(foo_params)
    rescue => e
      assert_equal e.class, JdPay::Error::InvalidRedirection
    end

    # valid param
    params = {
      'amount' => 'e5a6c3761ab9ddaf',
      'currency' => 'ac7132c57f10d3ce',
      'note' => '',
      'sign' => 'hO5dwBI6P9jpcPComYNzXct5P5Y2yHI4awojnp1xh1AaJseqegga5VsTV9GMlypXio8wK4PztvvP
 U4z14YMka0PDVkzuaA9LV7nPwbQQPj+0tT1F7kiVLIhk//Er2XtzNH93CwReKY9YZEP9NIsgaLTb
 dK6JAdQiOQyz6CN7dDY=',
      'status' => 'e00c693e6c5b8a60',
      'tradeNum' => '38442bada8fcc81581d733ff756dc840272bf690d6b0c0e4',
      'tradeTime' => 'c33390d9b3d6d6699706ea1467616603a2a1506bbaaf0f59'
    }

    decrypted_param = JdPay::Service::V1.verify_redirection(params)
    assert_equal decrypted_param, {"amount"=>"1", "currency"=>"CNY", "note"=>"", "status"=>"0", "tradeNum"=>"dev-1531882041-111", "tradeTime"=>"20180718104826"}


    # valid param & note is not null
    new_params = {
      'amount' => 'e5a6c3761ab9ddaf',
      'currency' => 'ac7132c57f10d3ce',
      'note' => '0f0071f565cf49ef82aeee8910e9f2f4',
      'sign' => 'hqbVC4wf2MLFC7bZZR1mofzc+uLQTNNZiyzpGR/1iq51DcFwrtN4/esOIVVYF2hX/+YNXOL9y5Ii
 i7/6Rs3z/ozROFOzD72t/nvpUI+6gOVjxgAui8bn/K3xkyl0Bo8QgBt16e6KnnRW5QVvJ2jjZRyG
 rzWFH/zgZf06cNaWolY=',
      'status' => 'e00c693e6c5b8a60',
      'tradeNum' => '38442bada8fcc815cc6386f24131481a4205f9d165019e8f',
      'tradeTime' => 'c33390d9b3d6d669fa4bbfc60f925498fe8ac39c72e43a1f'
    }
    new_decrypted_param = JdPay::Service::V1.verify_redirection(new_params)
    assert_equal new_decrypted_param, {"amount"=>"1", "currency"=>"CNY", "note"=>"test product", "status"=>"0", "tradeNum"=>"dev-1531992606-125", "tradeTime"=>"20180719173221"}
  end
end
