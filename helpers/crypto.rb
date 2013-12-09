class Application < Sinatra::Base
  helpers do
    def encrypt(value)
      iv = OpenSSL::Cipher::Cipher.new('aes-256-cbc').random_iv
      encrypted = Encryptor.encrypt(:value => value, :key => CONFIG['SHA256_SECRET'], :iv => iv)
      return Base64.encode64(encrypted), Base64.encode64(iv)
    end

    def decrypt(value, iv)
      value = Base64.decode64(value)
      iv = Base64.decode64(iv)
      Encryptor.decrypt(:value => value, :key => CONFIG['SHA256_SECRET'], :iv => iv)
    end
  end
end