module EpinCipher
  KEY = 'xiaodazpdarenc0m'
  IV = 'Xiaodac0mzpdaren'
  def self.aes128_encrypt(data)
    aes = OpenSSL::Cipher::AES.new("128-CBC")
    aes.encrypt
    aes.key = KEY
    aes.iv = IV
    r = aes.update(data) + aes.final
    Base64.urlsafe_encode64(r)
  end

  def self.aes128_decrypt(data)
    aes = OpenSSL::Cipher::AES.new("128-CBC")
    aes.decrypt
    aes.key = KEY
    aes.iv = IV
    r = Base64.urlsafe_decode64(data)
    aes.update(r) + aes.final
  end
end
