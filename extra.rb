require 'openssl'

module OmniAuth
  module Facebook
    class SignedRequest
      class UnknownSignatureAlgorithmError < NotImplementedError; end
      SUPPORTED_ALGORITHM = 'HMAC-SHA256'

      attr_reader :value, :secret

      def self.parse(value, secret)
        new(value, secret).payload
      end

      def initialize(value, secret)
        @value = value
        @secret = secret
      end

      def valid_signature?(signature, payload, algorithm = OpenSSL::Digest::SHA256.new)
        OpenSSL::HMAC.digest(algorithm, secret, payload) == signature
      end

      def base64_decode_url(value)
        value += '=' * (4 - value.size.modulo(4))
        Base64.decode64(value.tr('-_', '+/'))
      end
    end
  end
end