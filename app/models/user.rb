class User < ApplicationRecord

  validates :name, length:{maximum:10}
  validates :email, presence: true, uniqueness: true

  has_secure_password
  validates :password, presence: true, length:{minimum:8}
end
