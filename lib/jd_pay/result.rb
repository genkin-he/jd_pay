module JdPay
  class Result < ::Hash
    SUCCESS_FLAG = '000000'.freeze

    def initialize(result, options = {})
      super nil

      self['jdpay'] = result['jdpay']

      if result['jdpay'].class == Hash && (decrypt = self.verify_decrypt(options = {})).class == Hash
        self['jdpay'] = decrypt['jdpay']
      end
    end

    def success?
      self['jdpay']['result']['code'] == SUCCESS_FLAG
    end

    def verify_decrypt(options = {})
      raise JdPay::Error::DecryptVerifyErr, "#{self}" unless self.success?
      content_hash = Hash.from_xml JdPay::Des.decrypt_3des(Base64.decode64(self['jdpay']['encrypt']), options)
      return content_hash if JdPay::Sign.rsa_verify?(content_hash, options)
      raise JdPay::Error::DecryptVerifyErr, "#{content_hash}"
    end
  end
end
