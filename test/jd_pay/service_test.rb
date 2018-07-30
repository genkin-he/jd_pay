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

  def test_uniorder
    stub_request(:post, JdPay::Service::UNIORDER_URL).to_return(body: @response_body)
    params = {
      tradeNum: '123456780',
      tradeName: '测试商品',
      amount: '1',
      orderType: '0',
      userId: '123456',
      notifyUrl: 'http://making.dev/notify'
    }
    assert_equal @result, JdPay::Service.uniorder(params)
  end

  def test_query
    stub_request(:post, JdPay::Service::QUERY_URL).to_return(body: @response_body)
    params = {
      tradeNum: '12345678',
      tradeType: '1',
      oTradeNum: "12345677",
    }
    assert_equal @result, JdPay::Service.query(params)
  end

  def test_refund
    stub_request(:post, JdPay::Service::REFUND_URL).to_return(body: @response_body)
    params = {
      tradeNum: '12345678',
      oTradeNum: "12345677",
      amount: '1',
      notifyUrl: 'http://making.dev/notify',
    }
    assert_equal @result, JdPay::Service.refund(params)
  end

  def test_pc_pay
    html_str = "<html><body onload=document.getElementById('payForm').submit(); style='display: none;'><form action=https://wepay.jd.com/jdpay/saveOrder method='post' id='payForm'><input type='text' name=version value=V2.0><input type='text' name=merchant value=22294531><input type='text' name=tradeTime value=d9668085c69c2ecb73421627b78590400135be4ad908a2a7><input type='text' name=currency value=ac7132c57f10d3ce><input type='text' name=tradeNum value=b9a9953b73f9f8eb3612d06b873f74e9><input type='text' name=tradeName value=25fc4ff3e72f364fc1d80691e88fd7df><input type='text' name=amount value=e5a6c3761ab9ddaf><input type='text' name=orderType value=e00c693e6c5b8a60><input type='text' name=notifyUrl value=d54a8a984359284ec3d58d814e65630300d528555ef1e14ebe9ff87c62d78770><input type='text' name=callbackUrl value=b470f968b7165dcf745e8e129f073434ef9ec43bd64dda9ba2fe77001f4c7347><input type='text' name=userId value=29d899fc35dc7aa50640156c06e5ec0f><input type='text' name=sign value=di/QyXcBJGY/Avb8ilTEUsCxto6F5fbjX4mvGt0a0J2XD1dTJ8sPidfTHofagsgz9H/CP3FC6Hqca49woS7o8vkn4oPfA+coHfxBnm4QtBcvdeQjW3fKq2IKbtGG7UGNGXEJc9Gk7BnXNnuvnbEc5FVFcvbqirdNi+7opO9jmaM=></form></body></html>"
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
    assert_equal html_str, JdPay::Service.pc_pay(params)
  end

  def test_h5_pay
    html_str = "<html><body onload=document.getElementById('payForm').submit(); style='display: none;'><form action=https://h5pay.jd.com/jdpay/saveOrder method='post' id='payForm'><input type='text' name=version value=V2.0><input type='text' name=merchant value=22294531><input type='text' name=tradeTime value=d9668085c69c2ecb73421627b78590400135be4ad908a2a7><input type='text' name=currency value=ac7132c57f10d3ce><input type='text' name=tradeNum value=b9a9953b73f9f8eb3612d06b873f74e9><input type='text' name=tradeName value=25fc4ff3e72f364fc1d80691e88fd7df><input type='text' name=amount value=e5a6c3761ab9ddaf><input type='text' name=orderType value=e00c693e6c5b8a60><input type='text' name=notifyUrl value=d54a8a984359284ec3d58d814e65630300d528555ef1e14ebe9ff87c62d78770><input type='text' name=callbackUrl value=b470f968b7165dcf745e8e129f073434ef9ec43bd64dda9ba2fe77001f4c7347><input type='text' name=userId value=29d899fc35dc7aa50640156c06e5ec0f><input type='text' name=sign value=di/QyXcBJGY/Avb8ilTEUsCxto6F5fbjX4mvGt0a0J2XD1dTJ8sPidfTHofagsgz9H/CP3FC6Hqca49woS7o8vkn4oPfA+coHfxBnm4QtBcvdeQjW3fKq2IKbtGG7UGNGXEJc9Gk7BnXNnuvnbEc5FVFcvbqirdNi+7opO9jmaM=></form></body></html>"
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
    assert_equal html_str, JdPay::Service.h5_pay(params)
  end

  def test_revoke
    stub_request(:post, JdPay::Service::REVOKE_URL).to_return(body: @response_body)
    params = {
      tradeNum: '12345678',
      oTradeNum: "12345677",
      amount: '1',
    }
    assert_equal @result, JdPay::Service.revoke(params)
  end

  def test_notify_verify
    assert_equal @result, JdPay::Service.notify_verify(@response_body)
  end

  def test_user_relation
    xml_str = <<-EOF
    <jdpay>
      <version>V2.0</version>
      <merchant>22294531</merchant>
      <result>
        <code>000000</code>
        <desc>成功</desc>
      </result> <encrypt>OWQxYWMyN2I1M2M1NmJhNThjNjc0YmY1ZWJlY2QyODU0YTc5NmQ3ZWQxMWU1NzE3MWQ0OTUwOGI5NzllYmE4ZjM1YzRiZjlmYWE1M2ZiYjVjYTg5YjA4NTdhMjg3NTBhNzQxM2ZjOWFlN2U3YTNlYzM5ZTI5OTBkZDczNzQ5MjhjM2UxMjhkYWJhMGM0NWY2MWFjYjg2YWFlZDBjOTQ1Y2UyOWNlMDg2MmViOTQ3ZDUyZTczOTMxYjM0NGQwZTNjZGVjZTNkY2EwZmZlYzZlODE1Njc3YWMzODcyNTRhYTcyZDc5MjNhYzc5YWIzZGM0ZGIwYWE4NTc3ZTRhNmE3YmMxMjIwMmEyZmRjMDgxNjhlZjQ5ODVlNGIwNmU2ZTVjZjk3MWRlMmQ5NWYxMmJjNmUwZTdkNTJlZjBmNDhlYzIwZDYzY2U1NGY4ZGU2YWIxNDE5OTk0ZjAwZDE0MzdkZmE1NGZjMGRhOTFhZGM1ZDg5MGY3NWU5MmQxMDYyYmZjZDZiNDA4NjhkMjdlYzYwNmEzYTk4YzRhYzQ5ZGM0NjhmN2M0MTYzZTQxMjNiYzhkOWQ1ZjcwOTU4ZDk5NmM1MWEyZDY1MDk4NjJhZmMyZTI0Y2M0YmQxYmRiMTYyOWZlYzY4ZTBkNTk3NjFjMWYxNDJhNTdjMzBiZWM4ZDE1ZGQyNDY3MGFlMGM0YzMzYjllZWMzZDYzY2MxNmZmOGNmNDc4YzYzZjJiZDRjOGY2YzYxZTgzMWVlM2E5YzEyZTM5ZmEwMjM0OTdjZTJjMjNlZWEyOGRkMGE5MGMyMTg5OGY3MTUwN2Q1MDI0OWVhNDE1ZDFkOTllYTI0MWZlNmU1NTQ5ZTg5MzhlYTJhNjVmZDk3ZTE0MDQ5ZmJiNjMzMDMzMDA0YTUwN2ZiMmYyYmFkN2E3OTZjNjZmZDgzMDVlZmQ3MjcwMzg0ZmU2ZTMxM2QyZjgxZjcxYWZlYzZmY2EzYg==</encrypt>
    </jdpay>
    EOF
    stub_request(:post, JdPay::Service::USER_RELATION_URL).to_return(body: xml_str)
    expect_xml = <<-EOF
    <?xml version="1.0" encoding="UTF-8"?><jdpay><version>V2.0</version><merchant>22294531</merchant><result><code>000000</code><desc>成功</desc></result><isHas>true</isHas><sign>I1DPdvxF60UYSeTXbv+R3jnjp/Vy21paYo7pxgh6Wb/S1pjf4Cj0gOGYeCfWQullVrpL3UqGD/ZnX7Fz5Y8iuIaCgs0w3xGwe9Ww4MsxKnrzfRQ/sJhfZ9WE/3zJpQfg5yr5bVXrKROoBPjkpbWp78YH0KANZOV2EE0XkivwGJI=</sign></jdpay>
    EOF
    assert_equal Hash.from_xml(expect_xml), JdPay::Service.user_relation({userId: "123"})
  end

  def test_cancel_user
    xml_str = <<-EOF
    <jdpay>
      <version>V2.0</version>
      <merchant>22294531</merchant>
      <result>
        <code>000000</code>
        <desc>成功</desc>
      </result> <encrypt>ZmI3YmM5ZTVlODJhYzkyMjhjNjc0YmY1ZWJlY2QyODU0YTc5NmQ3ZWQxMWU1NzE3MWQ0OTUwOGI5NzllYmE4ZjM1YzRiZjlmYWE1M2ZiYjVjYTg5YjA4NTdhMjg3NTBhNzQxM2ZjOWFlN2U3YTNlYzM5ZTI5OTBkZDczNzQ5MjhjM2UxMjhkYWJhMGM0NWY2MWFjYjg2YWFlZDBjOTQ1Y2UyOWNlMDg2MmViOTQ3ZDUyZTczOTMxYjM0NGQwZTNjZGVjZTNkY2EwZmZlYzZlODE1Njc3YWMzODcyNTRhYTcyZDc5MjNhYzc5YWIzZGM0ZGIwYWE4NTc3ZTRhNmE3YmMxMjIwMmEyZmRjMDgxNjhlZjQ5ODVlNGIwNmU2ZTVjZjk3MWRlMmQ5NWYxMmJjNjJlY2EwNGM0ZDFiYzZmYzQ0NDc4N2IwNWEzZjYwZDZjZDUzNDJlYzFiOWY2NGFkOGU5OGQ3ZThkMzE1ZDQzYWQ0YjJlMmE1ZWZkZjEyZWU0ZTBkZmRhMjdmY2VhMzc3N2ZiYzIwZjdjZmFhNWU3NDU5ZmM2MDRjNzQ5MjA2MmNjNjJjYmZiNzJkOWJiZGMyODQzOTE1NzIxNDMwODc0NmZiNWZjYmYxMGU1MTY4MjVlOTU3YWE1Mzg0ZDU0ODJmOTAwYWFlMjA3M2I3NGQxMDRiZDk5YzM0MDViODY5NjBhZjY3NDM2MWNlNzlmMmFmOGVkNDBhZmRiZWMwODkwM2NiOTZlNzcwNzk2OTYwZDNlZDM1ZGEwM2YxZmEwYTQ1Mzc3ZTQzNWNkZmVlNzE4OTYyYjkyOWFiM2ZmYjdlODc3NjI1ZWFiYzU4NTYxNWJjNGY5ODk3MjdkZTViMjUwNDZmYWJlMWZiZWI1MWUxZWNlMzQzYmE3YzkxNTUzMDI4OTBjYzU0YTJiMGM2Yjg1ZTQ=</encrypt>
    </jdpay>
    EOF
    stub_request(:post, JdPay::Service::CANCEL_USER_URL).to_return(body: xml_str)
    expect_xml = <<-EOF
    <?xml version="1.0" encoding="UTF-8"?><jdpay><version>V2.0</version><merchant>22294531</merchant><result><code>000000</code><desc>成功</desc></result><sign>DUUlg3VLAFgx7vT6nCRBagmyJ8O8xsGC70kb6z9FjSO6vy3Vi7VNJ9rYizT+zP4JXOWxyeOAcgpY4O1I5tT1xrmh0N6k/z8PmRbKYXjUNNY999+teh5Ahwy9aigHw0u1ilWFcKmAMhF1gfyjX66WSKxMQASnDHTCEh8m1VBf76o=</sign></jdpay>
    EOF
    assert_equal Hash.from_xml(expect_xml), JdPay::Service.cancel_user({userId: "123"})
  end

  def test_pc_pay_with_getting_redirect_url
    stub_request(:post, JdPay::Service::PC_PAY_URL).with(headers:  {'Content-Type' => 'application/x-www-form-urlencoded'}, body: {
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
    assert_equal 'https://wepay.jd.com/jdpay/payCashier?tradeNum=12345678&ourTradeNum=1234567890&key=fookey', JdPay::Service.pc_pay(params, {:need_redirect_url => true})
  end

  def test_h5_pay_with_getting_redirect_url
    stub_request(:post, JdPay::Service::H5_PAY_URL).with(headers:  {'Content-Type' => 'application/x-www-form-urlencoded'}, body: {
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
    assert_equal 'https://h5pay.jd.com/jdpay/payCashier?tradeNum=12345678&ourTradeNum=1234567890&key=fookey', JdPay::Service.h5_pay(params, {:need_redirect_url => true})
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
      decrypted_param = JdPay::Service.verify_redirection(foo_params)
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
    decrypted_param = JdPay::Service.verify_redirection(params)
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
    new_decrypted_param = JdPay::Service.verify_redirection(new_params)
    assert_equal new_decrypted_param, {"amount"=>"1", "currency"=>"CNY", "note"=>"test product", "status"=>"0", "tradeNum"=>"dev-1531992606-125", "tradeTime"=>"20180719173221"}
  end
end
