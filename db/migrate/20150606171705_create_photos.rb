class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.text :description
      t.attachment :image

      t.integer :linkable_id
      t.integer :linkable_type

      t.timestamps null: false
    end
    add_index :photos, [:linkable_id, :linkable_type]
  end
end
