class User < ApplicationRecord

  attr_accessor :avatar_file

  has_secure_password
  has_secure_token :confirmation_token
  has_secure_token :recover_password

  before_save :avatar_before_upload
  after_save :avatar_after_upload
  after_destroy_commit :avatar_destroy

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

  validates :avatar_file, file: {
      ext: [:jpg, :jpeg, :png],
      message: "Les extensions autoriseés sont uniquement JPG, JPEg et PNG"
  }

  def to_session
    {id: id}
  end

  def avatar_path
    path = File.join(Rails.public_path, self.class.name.downcase.pluralize, id.to_s, 'avatar.jpg')
  end

  def avatar_url
    '/' + [self.class.name.downcase.pluralize, id.to_s, 'avatar.jpg'].join('/')
  end

  private


  def avatar_before_upload
    if avatar_file.respond_to? :path
      self.avatar = true
    end
  end

  def avatar_after_upload
    path = avatar_path
    if avatar_file.respond_to? :path
      dir  = File.dirname(path)
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      image = MiniMagick::Image.new(avatar_file.path) do |b|
        b.resize '150x150^'
        b.gravity 'Center'
        b.crop '150x150+0+0'
      end
      image.format 'jpg'
      image.write path
    end
  end

  def avatar_destroy
    dir = File.dirname(avatar_path)
    FileUtils.rm_r(dir) if Dir.exist?(dir)
  end

end
