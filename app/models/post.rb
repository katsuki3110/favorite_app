class Post < ApplicationRecord
  belongs_to :user
  has_many   :spots, dependent: :destroy
  has_many   :likes, dependent: :destroy
  has_many   :users, through: :likes, foreign_key: :post_id

  mount_uploader :image_post, PostImageUploader

  validates :title, presence: true, length:{maximum: 30}
  validates :place, presence: true, length:{maximum: 10}
  validates :overview, presence: true, length:{maximum: 100}

  accepts_nested_attributes_for :spots, allow_destroy: true



end
