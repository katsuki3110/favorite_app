class AddImageToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :image_post, :string
  end
end
