# JdPay

A unofficial jdpay ruby gem.
Thanks for [alipay](https://github.com/chloerei/alipay) and [wx_pay](https://github.com/jasl/wx_pay)

JdPay official document: http://payapi.jd.com/.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jdpay'
```

or development version

```ruby
gem 'jdpay', :github => 'genkin-he/jdpay'
```

And then execute:

```sh
$ bundle
```

## Configuration

```ruby
require 'jd_pay'
# NOTE: 京东支付与京东付款码支付是两套账号密钥.
# 京东支付配置
JdPay.mch_id = 'YOUR_MERCHANT_NUM'
JdPay.des_key = 'YOUR_3DES_KEY'
JdPay.md5_key = 'YOUR_MD5_KEY'
JdPay.pri_key = 'YOUR_RSA_PRIVATE_KEY'
# 京东付款码支付配置
JdPay.qr_mch_id = 'YOUR_MERCHANT_NUM'
JdPay.qr_des_key = 'YOUR_3DES_KEY'
JdPay.qr_pri_key = 'YOUR_RSA_PRIVATE_KEY'

#JdPay.pub_key = 'JDPAY_RSA_PUBLIC_KEY'
#JdPay.debug_mode = true # Enable parameter check. Default is true.
```

*重要*：

根据文档中的Q&A
> 支付请求和异步返回的加密规则是什么？
  答：支付请求用pkcs8的RSA私钥进行签名，des加密；
    同步返回使用京东支付统一对外rsa公钥验签；
    异步返回用3DES解密，京东支付统一对外rsa公钥验签。

因此请勿为`JdPay.pub_key`设置你自己产生的公钥，默认不填就行。

You can set default key, or pass a key directly to service method:

```ruby
Service.uniorder({
  tradeNum: 'TRADE_NUM',
}, {
  mch_id: 'YOUR_MERCHANT_NUM',
  des_key: 'YOUR_3DES_KEY',
  md5_key: 'YOUR_MD5_KEY',
  pri_key: 'YOUR_RSA_PRIVATE_KEY'
})
```

## Service(京东支付账户)
  Check **[JdPay official document](http://payapi.jd.com/)** for detailed request params and return fields

### 统一下单接口

#### Name && Description
> 商户系统先调用该接口在京东支付服务后台生成交易单，再按扫码、APP等不同场景发起支付

```ruby
uniorder
```
#### Definition

```ruby
JdPay::Service.uniorder(params, options = {})
```
#### Example

```ruby
# required fields
# [:tradeNum, :tradeName, :amount, :orderType, :notifyUrl, :userId]
params = {
  tradeNum: '123456780',
  tradeName: '测试商品',
  amount: '1',
  orderType: '0',
  notifyUrl: 'http://making.dev/notify',
  userId: '123456780'
}
result = JdPay::Service.uniorder(params)

# Used for app
signData = JdPay::Sign.md5_sign(result['jdpay']['orderId'], options)
```
### 在线支付接口PC
#### Name && Description
> 支付请求接口提供给商户向京东支付服务发送支付请求数据集合，京东支付服务会根据请求数据验证商户身份，以及验证支付信息是否被篡改。验证通过后，京东支付服务会在当前页面弹出支付页面弹框。

```ruby
pc_pay
```
#### Definition

```ruby
# 返回构建的表单，表单会自动发送POST请求，请求成功京东会进行页面跳转
JdPay::Service.pc_pay(params, options = {})

# 获取Redirect URL，前端获取后可以直接跳转京东收银台
JdPay::Service.pc_pay(params, {:need_redirect_url => true})
```
#### Example
```ruby
  # required keys
  # [:tradeNum, :tradeName, :amount, :orderType, :notifyUrl, :callbackUrl, :userId]
  params = {
    tradeNum: '12345678',
    tradeName: '测试商品',
    amount: '1',
    orderType: '0',
    notifyUrl: 'http://making.dev/notify',
    callbackUrl: 'http://frontend.com/return',
    userId: "0000001"
  }
  JdPay::Service.pc_pay(params)
```
### 在线支付接口H5
#### Name && Description
> 在线支付接口的手机版本，用法参照在线支付PC接口，不再赘述。

```ruby
h5_pay
```
#### Definition

```ruby
# 返回构建的表单，表单会自动发送POST请求，请求成功京东会进行页面跳转
JdPay::Service.h5_pay(params, options = {})

# 获取Redirect URL，前端获取后可以直接跳转京东收银台
JdPay::Service.h5_pay(params, {:need_redirect_url => true})
```

### 交易查询接口
#### Name && Description
> 交易查询接口是为了处理商户服务器长时间没有接收到支付结果的情况设计的。一般情况，支付结果会通过前端同步返回和京东支付服务器的异步通知发送到商户服务。但是为避免特殊情况商户服务器仍然没有接收到支付结果，这时候商户服务可以通过主动查询交易结果的接口查询支付状态。

```ruby
query
```
#### Definition

```ruby
JdPay::Service.query(params, options = {})
```
#### Example

```ruby
  # required keys:
  #   cost trade query [:tradeNum, :tradeType]
  #   refund trade query [:tradeNum, :oTradeNum, :tradeType]
  params = {
    tradeNum: '12345678',
    tradeType: '1',
    oTradeNum: "12345677",
  }
  JdPay::Service.query(params)
```

### 退款申请接口
#### Name && Description
> 退款申请接口提供给商户发起自动退款的能力。如果用户在商户系统下单支付以后发起退款，商户验证通过之后可以自动发起退款请求。同时京东支付商户管理后台提供手动退款的功能。

```ruby
refund
```
#### Definition

```ruby
JdPay::Service.refund(params, options = {})
```
#### Example

```ruby
  # refund required keys [:tradeNum, :oTradeNum, :amount, :notifyUrl]
  params = {
    tradeNum: '12345678',
    oTradeNum: "12345677",
    amount: '1',
    notifyUrl: 'http://making.dev/notify',
  }
  JdPay::Service.refund(params)
```

### 撤销申请接口
#### Name && Description
> 撤销申请接口提供给商户发起自动撤销的能力。对于未支付的订单撤销后不可再次支付，对于支付成功的订单则发起退款。

```ruby
revoke
```
#### Definition

```ruby
JdPay::Service.revoke(params, options = {})
```
#### Example

```ruby
  # revoke required keys [:tradeNum, :oTradeNum, :amount, :notifyUrl]
  params = {
    tradeNum: '12345678',
    oTradeNum: "12345677",
    amount: '1',
  }
  JdPay::Service.revoke(params)
```
### 异步通知解密验签
#### Name && Description
> 商户后台将收到的京东异步通知XML内容解密及验签.

```ruby
notify_verify
```
#### Definition

```ruby
JdPay::Service.notify_verify(xml_str, options = {})
```
#### Example

```ruby
  # notify_verify required xml_str
  xml_str = <<-EOF
  <?xml version=\"1.0\" encoding=\"UTF-8\" ?>
  <jdpay>
    <version>V2.0</version>
    <merchant>22294531</merchant>
    <result>
      <code>000000</code>
      <desc>成功</desc>
    </result>
    <encrypt>MWM0MjhjYjk3YjhjNzZiNThjNjc0YmY1ZWJlY2QyODU0YTc5NmQ3ZWQxMWU1NzE3MWQ0OTUwOGI5NzllYmE4ZjM1YzRiZjlmYWE1M2ZiYjVjYTg5YjA4NTdhMjg3NTBhNzQxM2ZjOWFlN2U3YTNlYzM5ZTI5OTBkZDczNzQ5MjhjM2UxMjhkYWJhMGM0NWY2MWFjYjg2YWFlZDBjOTQ1Y2UyOWNlMDg2MmViOTQ3ZDUyZTczOTMxYjM0NGQwZTNjZGVjZTNkY2EwZmZlYzZlODE1Njc3YWMzODcyNTRhYTcyZDc5MjNhYzc5YWIzZGM0ZGIwYWE4NTc3ZTRhNmE3YmMxMjIwMmEyZmRjMDgxNjhlZjQ5ODVlNGIwNmU2ZTVjZjk3MWRlMmQ5NWYxMmJjNjQ3ZTY3MzhhNzRlOGJlMThlNzY0ZjJkYTAwODJjODNlMTlhZThlMjliYjIwZDVlNGM5NmNiZjJiZmZiNzViOWM2ZTE5Yjk5NWNlNGFhYjc5OTRhZmEyYzA4NjFiZmQ4OGM3ZmIwMzdjODlkOTU4MWQ1ZTc5MGY0NjIxZDY5M2ZjNzRiZDIwMTMyMGM5N2I5NzM1YjlkOTJjNDc5NTg5NzZlNTk0ZTJjMWZkNzU2YjAzOTFiMTRjZWI0MzJjNzhjNmVhNGY3OTM0MWU4NGI5Y2FmY2VjNWU3NGNlY2E1MjBiOTdlYjNiYmFkZDkyNmJhOWI3OTI4ZGQ5NTczMDY0ZmFiMjc5NzBkMmQ2ZTljMjM1MTM4N2E4MDhkZmUzMzc3Yzg5M2EzM2I0ZmU4MTA0MjA5YjA2YzUzMDZlNzNjNDQzZGU5OWRmMjk0YzU2YTUwMGZiYWMyNzhiOTVmM2ExMDk1NzFlZDE5NTZhMzM5MjI1Mjk3NmVlMjYwODJjOWMyNjUyMDllMzE4ZTBmMTY0MDgzYTU0ODMyOTFmNTFhMTcyMGYwMTQwOTg1NjdkYjZkZGZhZjI5NzE1ZTA5YjFhNDczNjZkNTY3MDYwZDRmZmIzZjVjNjgyZTczZjFmNjJmY2YxYWE1NDAxZDk4NDE0NjdhZDE5OTMxZGZkZDdjNWI0YzZlNTkzNjU3OGRkZTA1MmNhM2JiZDhmYjg3NWE3NDY2NjA0YTU0M2ExOWNiZjQyNzlhM2UyMDc3MzI3YjI3NWFlYjQ3ZmU3NjMyZTAxN2E4ZmZkY2UyZjg3M2I2ZTcwYTE4Y2MzNWE3YjFiNmZjYzJkY2E4MjNkZGNmNmFhOWRlZWQzYjE3NTI5MGQ5NDZkMTQ5NmFhZjJiOGM0OGEwNzU3OGM4ODIzZTVhNTU2YjU1OTk5ZTJiMjEwYmYzMjFmN2M5MmU3Yzc2NjJiMzdmNmI1Y2JjNjFiYjllYjY0Zjc3NWMwMDVlNGY4YmVjNzhmZWNmZGFmNWJkNjc2ODY1ZTAwYzllODRkNjg2ZDNmZTBjOTJiOTYwMjlmMWIxYThjMzQzYmE3YzkxNTUzMDI4OTBjYzU0YTJiMGM2Yjg1ZTQ=</encrypt>
  </jdpay>
  EOF

  JdPay::Service.notify_verify(xml_str)
```

### 支付成功页面跳转
#### Name && Description
> 用户支付成功后，京东支付系统根据支付接口中callbackUrl所传地址跳转到商户的支付成功页，并采用POST方式回传相应的订单参数。

```ruby
verify_redirection
```
#### Definition
```ruby
JdPay::Service.verify_redirection(params, options = {})
```
#### Example
```ruby
# In your controller:
begin
  decrypted_params = JdPay::Service.verify_redirection(request.params, {})
rescue => e
  render :status => :bad_request
  return
end
```

### 用户关系查询接口
#### Name && Description
> 若商户用户与京东用户关联，下次支付时可跳过身份识别环境进行支付。此接口提供了用户关系查询功能。

```ruby
user_relation
```
#### Definition

```ruby
JdPay::Service.user_relation(params, options = {})
```
#### Example

```ruby
  # user_relation required keys [:userId]
  params = { userId: '12345678' }
  JdPay::Service.user_relation(params)
```
### 用户关系解绑接口
#### Name && Description
> 解绑用户关系，解绑后，用户下一次支付，需重新通过手机等登录方式进行身份验证。

```ruby
cancel_user
```
#### Definition

```ruby
JdPay::Service.cancel_user(params, options = {})
```
#### Example

```ruby
  # cancel_user required keys [:userId]
  params = { userId: '12345678' }
  JdPay::Service.cancel_user(params)
```
## QrService(京东付款码账户)

### 京东付款码支付接口

#### Name && Description
> 付款码支付接口用于客户使用付款码支付时，商户使用扫码枪完成一键下单并支付功能。在支付过程中对支付请求进行校验后，完成支付流程。

```ruby
qrcode_pay
```
#### Definition

```ruby
JdPay::QrService.qrcode_pay(params, options = {})
```
#### Example

```ruby
# required fields
# [:tradeNum, :tradeName, :amount, :device, :token]
params = {
  tradeNum: '123456780',
  tradeName: '测试商品',
  amount: '1',
  device: '0001',
  token: '2563256985478547856'
}
JdPay::QrService.qrcode_pay(params)
```
### 京东付款码交易查询
#### Definition

```ruby
JdPay::QrService.query(params, options = {})
```
#### Example

```ruby
# refer to：JdPay::Service.query(params, options = {})
```
### 京东付款码交易退款
#### Definition

```ruby
JdPay::QrService.refund(params, options = {})
```
#### Example

```ruby
# refer to：JdPay::Service.refund(params, options = {})
```
### 京东付款码异步通知解密验签
#### Definition

```ruby
JdPay::QrService.notify_verify(params, options = {})
```
#### Example

```ruby
# refer to：JdPay::Service.notify_verify(params, options = {})
```


## Contributing

Bug report or pull request are welcome.

### Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Donate
Donate to maintainer let him make this gem better.

[donate link](https://ruby-china.org/hemengzhi88).<br/>

<!-- <img src="https://raw.githubusercontent.com/genkin-he/md_photos/master/alipay.jpg" alt="alipay" width="200" align='left'> -->
<!-- <img src="https://raw.githubusercontent.com/genkin-he/md_photos/master/wx_pay.png" alt="wx_pay" width="220" align='left'> -->
