require 'rest_client'
require 'active_support/core_ext/hash/conversions'
require 'jd_pay/error'

module JdPay
  module Service
    module V1
      H5_PAY_URL = 'https://h5pay.jd.com/jdpay/saveOrder'
      PC_PAY_URL = 'https://wepay.jd.com/jdpay/saveOrder'
      WEB_PAY_BASE_URL = 'https://wepay.jd.com/jdpay'
      H5_PAY_BASE_URL = 'https://h5pay.jd.com/jdpay'

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
          get_redirect_url(url, params)
        end

        def verify_notification(xml_str, options = {})
          JdPay::Result.new(Hash.from_xml(xml_str), options)
        end

        def verify_redirection(params, options = {})
          params = params.dup
          sign = params.delete('sign')
          decrypted_and_dropped = JdPay::Util.decrypt_and_drop_empty(params)
          decrypted, dropped = decrypted_and_dropped[0], decrypted_and_dropped[1]
          params = JdPay::Util.stringify_keys(dropped)
          string = JdPay::Util.params_to_string(params)
          raise JdPay::Error::InvalidRedirection.new unless Digest::SHA256.hexdigest(string) === JdPay::Sign.rsa_decrypt(sign, options)
          decrypted
        end

        private

        def check_required_options(options, names)
          return unless JdPay.debug_mode?
          names.each do |name|
            warn("JdPay Warn: missing required option: #{name}") unless options.has_key?(name)
          end
        end

        def get_redirect_url(url, payload)
          base_url = WEB_PAY_BASE_URL
          base_url = H5_PAY_BASE_URL if url === H5_PAY_URL
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
          if resp['location'].include? base_url
            redirect = resp['location']
          else
            redirect = base_url + '/' + resp['location']
          end
          redirect
        end
      end
    end
  end
end
