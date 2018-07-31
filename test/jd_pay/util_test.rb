require 'test_helper'

class JdPay::UtilTest < Minitest::Test
  def setup
    @params = {he: 'zhi', zhi: 'he', meng: nil}
  end

  def test_denilize
    assert_equal @params.merge(meng: ""), JdPay::Util.denilize(@params)
  end

  def test_to_xml
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><jdpay><he>zhi</he><zhi>he</zhi><meng></meng></jdpay>"
    assert_equal xml, JdPay::Util.to_xml(@params)
  end

  def test_xml_out
    params = {he: 'zhi', pay: [{pay_type: "1"}, {pay_type: "2"}]}
    xml = "<he>zhi</he><pay><pay_type>1</pay_type></pay><pay><pay_type>2</pay_type></pay>"
    assert_equal xml, JdPay::Util.xml_out(params)
  end

  def test_to_query
    uri = "he=zhi&meng=&zhi=he"
    assert_equal uri, JdPay::Util.to_query(@params)
  end

  def test_build_pay_form
    url = "https://wepay.jd.com/jdpay/saveOrder"
    str = "<html><body onload=document.getElementById('payForm').submit(); style='display: none;'><form action=https://wepay.jd.com/jdpay/saveOrder method='post' id='payForm'><input type='text' name=he value=zhi><input type='text' name=zhi value=he><input type='text' name=meng value=></form></body></html>"
    assert_equal str, JdPay::Util.build_pay_form(url, @params)
  end
end
