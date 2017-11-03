class Authentication < ActiveRecord::Base
  before_validation :set_access_key
  before_validation :set_secret_key
  before_validation :set_salt
  before_save       :encrypt_password

  validates :client_name, presence: true
  validates :user_name, presence: true
  validates :password, presence: true
  validates :access_key, presence: true
  validates :secret_key, presence: true
  validates :salt, presence: true

  CIPHER = 'aes-256-cbc'

  def decrypted_password
    decrypt(password)
  end

  private

  def encrypt_password
    self.password = encrypt(password)
  end

  def set_access_key
    return if access_key.present?
    self.access_key = SecureRandom.uuid.gsub('-', '')
  end

  def set_salt
    return if salt.present?
    self.salt = SecureRandom.base64(24)
  end

  def set_secret_key
    return if secret_key.present?
    self.secret_key = SecureRandom.base64(32)
  end

  def encrypt(string)
    crypt = ActiveSupport::MessageEncryptor.new(salt, CIPHER)
    crypt.encrypt_and_sign(string)
  end

  def decrypt(string)
    crypt = ActiveSupport::MessageEncryptor.new(salt, CIPHER)
    crypt.decrypt_and_verify(string)
  end
end
