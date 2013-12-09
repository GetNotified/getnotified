class Application < Sinatra::Base
  helpers do
    def encrypt(value)
      iv = OpenSSL::Cipher::Cipher.new('aes-256-cbc').random_iv
      encrypted = Encryptor.encrypt(:value => value, :key => CONFIG['SHA256_SECRET'], :iv => iv)
      return encrypted, iv
    end

    def decrypt(value, iv)
      Encryptor.decrypt(:value => value, :key => CONFIG['SHA256_SECRET'], :iv => iv)
    end
  end
end