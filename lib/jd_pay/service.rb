require 'rest_client'
require 'active_support/core_ext/hash/conversions'

module JdPay
  module Service
    UNIORDER_URL = 'https://paygate.jd.com/service/uniorder'
    QUERY_URL = 'https://paygate.jd.com/service/query'
    REFUND_URL = 'https://paygate.jd.com/service/refund'
    H5_PAY_URL = 'https://h5pay.jd.com/jdpay/saveOrder'
    PC_PAY_URL = 'https://wepay.jd.com/jdpay/saveOrder'
    REVOKE_URL = 'https://paygate.jd.com/service/revoke'
    QRCODE_PAY_URL = 'https://paygate.jd.com/service/fkmPay'
    USER_RELATION_URL = 'https://paygate.jd.com/service/getUserRelation'
    CANCEL_USER_URL = 'https://paygate.jd.com/service/cancelUserRelation'
    WEB_PAY_BASE_URL = 'https://wepay.jd.com/jdpay/payCashier'
    H5_PAY_BASE_URL = 'https://h5pay.jd.com/jdpay/payCashier'

    class << self
      # the difference between pc and h5 is just request url
      def pc_pay(params, options = {})
        web_pay(params, PC_PAY_URL, options)
      end

      def h5_pay(params, options = {})
        web_pay(params, H5_PAY_URL, options)
      end

      WEB_PAY_REQUIRED_FIELDS = [:tradeNum, :tradeName, :amount, :orderType, :notifyUrl, :callbackUrl, :userId]
      def web_pay(params, url, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
          tradeTime: Time.now.strftime("%Y%m%d%H%M%S"),
          currency: "CNY"
        }.merge(params)

        check_required_options(params, WEB_PAY_REQUIRED_FIELDS)
        sign = JdPay::Sign.rsa_encrypt(JdPay::Util.to_query(params), options)
        skip_encrypt_params = %i(version merchant)
        params.each do |k, v|
          params[k] = skip_encrypt_params.include?(k) ? v : JdPay::Des.encrypt_3des(v)
        end
        params[:sign] = sign
        options[:need_redirect_url] ? get_redirect_url(url, params) : JdPay::Util.build_pay_form(url, params)
      end

      UNIORDER_REQUIRED_FIELDS = [:tradeNum, :tradeName, :amount, :orderType, :notifyUrl, :userId]
      def uniorder(params, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
          tradeTime: Time.now.strftime("%Y%m%d%H%M%S"),
          currency: "CNY"
        }.merge(params)

        check_required_options(params, UNIORDER_REQUIRED_FIELDS)
        params[:sign] = JdPay::Sign.rsa_encrypt(JdPay::Util.to_xml(params), options)

        JdPay::Result.new(Hash.from_xml(invoke_remote(UNIORDER_URL, make_payload(params), options)), options)
      end

      QRCODE_REQUIRED_FIELDS = [:tradeNum, :tradeName, :amount, :device, :token]
      def qrcode_pay(params, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
          tradeTime: Time.now.strftime("%Y%m%d%H%M%S"),
          currency: "CNY"
        }.merge(params)

        check_required_options(params, QRCODE_REQUIRED_FIELDS)
        params[:sign] = JdPay::Sign.rsa_encrypt(JdPay::Util.to_xml(params), options)

        JdPay::Result.new(Hash.from_xml(invoke_remote(QRCODE_PAY_URL, make_payload(params), options)), options)
      end

      USER_RELATION_REQUIRED_FIELDS = [:userId]
      def user_relation(params, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
        }.merge(params)

        check_required_options(params, USER_RELATION_REQUIRED_FIELDS)
        params[:sign] = JdPay::Sign.rsa_encrypt(JdPay::Util.to_xml(params), options)

        JdPay::Result.new(Hash.from_xml(invoke_remote(USER_RELATION_URL, make_payload(params), options)), options)
      end

      def cancel_user(params, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
        }.merge(params)

        check_required_options(params, USER_RELATION_REQUIRED_FIELDS)
        params[:sign] = JdPay::Sign.rsa_encrypt(JdPay::Util.to_xml(params), options)

        JdPay::Result.new(Hash.from_xml(invoke_remote(CANCEL_USER_URL, make_payload(params), options)), options)
      end

      REFUND_REQUIRED_FIELDS = [:tradeNum, :oTradeNum, :amount, :notifyUrl]
      def refund(params, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
          tradeTime: Time.now.strftime("%Y%m%d%H%M%S"),
          currency: "CNY"
        }.merge(params)

        check_required_options(params, REFUND_REQUIRED_FIELDS)
        params[:sign] = JdPay::Sign.rsa_encrypt(JdPay::Util.to_xml(params), options)

        JdPay::Result.new(Hash.from_xml(invoke_remote(REFUND_URL, make_payload(params), options)), options)
      end

      QUERY_REQUIRED_FIELDS = [:tradeNum, :tradeType]
      def query(params, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
          tradeType: '0'
        }.merge(params)

        check_required_options(params, QUERY_REQUIRED_FIELDS)
        params[:sign] = JdPay::Sign.rsa_encrypt(JdPay::Util.to_xml(params), options)

        JdPay::Result.new(Hash.from_xml(invoke_remote(QUERY_URL, make_payload(params), options)), options)
      end

      REVOKE_REQUIRED_FIELDS = [:tradeNum, :oTradeNum, :amount]
      def revoke(params, options = {})
        params = {
          version: "V2.0",
          merchant: options[:mch_id] || JdPay.mch_id,
          tradeTime: Time.now.strftime("%Y%m%d%H%M%S"),
          currency: "CNY"
        }.merge(params)

        check_required_options(params, REVOKE_REQUIRED_FIELDS)
        params[:sign] = JdPay::Sign.rsa_encrypt(JdPay::Util.to_xml(params), options)

        JdPay::Result.new(Hash.from_xml(invoke_remote(REVOKE_URL, make_payload(params), options)), options)
      end

      def notify_verify(xml_str, options = {})
        JdPay::Result.new(Hash.from_xml(xml_str), options)
      end

      def verify_redirection(params, options = {})
        params = params.dup
        sign = params.delete('sign')
        decrypted_and_dropped = JdPay::Util.decrypt_and_drop_empty(params)
        decrypted, dropped = decrypted_and_dropped[0], decrypted_and_dropped[1]
        params = JdPay::Util.stringify_keys(dropped)
        string = JdPay::Util.to_query(params)
        unless Digest::SHA256.hexdigest(string) == JdPay::Sign.rsa_decrypt(sign, options)
          raise JdPay::Error::InvalidRedirection, "decrypted:#{decrypted};dropped:#{dropped}"
        end
        decrypted
      end

      private

      def check_required_options(options, names)
        return unless JdPay.debug_mode?
        names.each do |name|
          warn("JdPay Warn: missing required option: #{name}") unless options.has_key?(name)
        end
      end

      def make_payload(params, options = {})
        request_hash = {
          "version" => "V2.0",
          "merchant" => options[:mch_id] || JdPay.mch_id,
          "encrypt" => Base64.strict_encode64(JdPay::Des.encrypt_3des JdPay::Util.to_xml(params))
        }
        JdPay::Util.to_xml(request_hash)
      end

      def invoke_remote(url, payload, options = {})
        options = JdPay.extra_rest_client_options.merge(options)

        RestClient::Request.execute(
          {
            method: :post,
            url: url,
            payload: payload,
            headers: { content_type: 'application/xml' }
          }.merge(options)
        )
      end

      def get_redirect_url(url, payload)
        base_url = WEB_PAY_BASE_URL
        base_url = H5_PAY_BASE_URL if url == H5_PAY_URL
        url = URI.parse(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(url.to_s)
        req.form_data = payload
        req['Content-Type'] = 'application/x-www-form-urlencoded'
        resp = http.request(req)
        # This is really a bad design by JDPay.
        # Examples:
        # For h5pay: https://h5pay.jd.com/jdpay/payCashier?tradeNum=xxx&orderId=xxx&key=xxx
        # For webpay: payCashier?tradeNum=xxx&ourTradeNum=xxx&key=xxx
        resp['location'].include?(base_url) ? resp['location'] : "#{base_url}?#{resp['location'].split('?')[1]}"
      end
    end
  end
end
