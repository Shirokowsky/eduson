class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.string :title
      t.string :description
      t.string :image

      t.integer :linkable_id
      t.integer :linkable_type

      t.timestamps null: false
    end
    add_index :links, [:linkable_id, :linkable_type]
  end
end
