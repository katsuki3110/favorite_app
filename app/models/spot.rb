class Spot < ApplicationRecord
  belongs_to :post

  mount_uploader :image_spot, SpotImageUploader

  validates :place,    presence: true, length:{maximum: 20}
  validates :explaine, presence: true, length:{maximum: 300}
end
