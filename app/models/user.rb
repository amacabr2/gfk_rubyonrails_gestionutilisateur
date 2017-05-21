class User < ApplicationRecord

  has_secure_password
  has_secure_token :confirmation_token

  validates :username, format: {
      with: /\A[a-zA-Z0-9_]{2,20}\z/,
      message: " ne doit contenir que des caractères alphanumériques ou des _"
  }, uniqueness: {
      case_sensitive: false,
      message: " Il éxiste déjà un compte avec ce pseudo"
  }

  validates :email, format: {
      with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/,
      message: "n'a pas l'air d'être un email"
  }, uniqueness: {
      case_sensitive: false,
      message: " Il éxiste déjà un compte avec ce mail"
  }

  def to_session
    {id: id}
  end

end
