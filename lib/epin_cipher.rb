module EpinCipher
  KEY = 'xiaoda@zpdaren.c0m'
  IV = 'Xiaoda.c0m@zpdaren'
  def self.aes128_encrypt(data)
    aes = OpenSSL::Cipher::AES.new("128-CBC")
    aes.encrypt
    aes.key = KEY
    aes.iv = IV
    r = aes.update(data) + aes.final
    Base64.encode64(r)
  end

  def self.aes128_decrypt(data)
    aes = OpenSSL::Cipher::AES.new("128-CBC")
    aes.decrypt
    aes.key = KEY
    aes.iv = IV
    r = Base64.decode64(data)
    aes.update(r) + aes.final
  end
end