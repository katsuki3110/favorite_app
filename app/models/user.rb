class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  has_many :following_relationships, class_name: 'Relationship',
                                     foreign_key: :following_id,
                                     dependent: :destroy
  has_many :followed_relationships,  class_name: 'Relationship',
                                     foreign_key: :followed_id,
                                     dependent: :destroy
  has_many :followings, through: :following_relationships, source: :followed
  has_many :followers,  through: :followed_relationships,  source: :following

  validates :name,  presence: true, length:{maximum:30}
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length:{minimum:8}, allow_nil: true
  validates :introduction, length:{maximum:180}

  mount_uploader :image_user, UserImageUploader

  before_save   :downcase_email
  before_create :create_activation_digest

  #パスワードのハッシュ化
  def User.digest(password)
    BCrypt::Password.create(password)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
