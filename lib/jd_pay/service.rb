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

    class << self
      # the difference between pc and h5 is just request url
      def pc_pay(params, options = {})
        web_pay(params, PC_PAY_URL, options = {})
      end

      def h5_pay(params, options = {})
        web_pay(params, H5_PAY_URL, options = {})
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
        sign = JdPay::Sign.rsa_encrypt(JdPay::Util.to_uri(params), options)
        skip_encrypt_params = %i(version merchant)
        params.each do |k, v|
          params[k] = skip_encrypt_params.include?(k) ? v : JdPay::Des.encrypt_3des(v)
        end
        params[:sign] = sign
        JdPay::Util.build_pay_form(url, params)
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
    end
  end
end
