require 'digest/md5'
require "base64"

module JdPay
  module Sign

    JDPAY_RSA_PUBLIC_KEY = <<EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCKE5N2xm3NIrXON8Zj19GNtLZ8
xwEQ6uDIyrS3S03UhgBJMkGl4msfq4Xuxv6XUAN7oU1XhV3/xtabr9rXto4Ke3d6
WwNbxwXnK5LSgsQc1BhT5NcXHXpGBdt7P8NMez5qGieOKqHGvT0qvjyYnYA29a8Z
4wzNR7vAVHp36uD5RwIDAQAB
-----END PUBLIC KEY-----
EOF

    class << self
      # params:
      #  :orderId
      def md5_sign(order_id, options = {})
        Digest::MD5.hexdigest(
          "merchant=#{options[:mch_id] || JdPay.mch_id}" +
          "&orderId=#{order_id}&key=#{options[:md5_key] || JdPay.md5_key}"
        )
      end

      def rsa_encrypt(str, options = {})
        private_key = OpenSSL::PKey::RSA.new(options[:pri_key] || JdPay.pri_key)
        Base64.strict_encode64(private_key.private_encrypt Digest::SHA256.hexdigest(str))
      end

      def rsa_decrypt(sign_str, options = {})
        public_key = OpenSSL::PKey::RSA.new(options[:pub_key] || JdPay.public_key)
        public_key.public_decrypt(Base64.decode64(sign_str))
      end

      def rsa_verify?(params, options = {})
        params = params['jdpay'].dup
        sign_str = params.delete('sign')
        xml_without_sign = JdPay::Util.to_xml(params, root: 'jdpay')
        ori_data = [xml_without_sign, xml_without_sign.gsub("?>", " ?>")].map do |xml|
          Digest::SHA256.hexdigest(xml)
        end
        ori_data.include? rsa_decrypt(sign_str, options)
      end
    end
  end
end
