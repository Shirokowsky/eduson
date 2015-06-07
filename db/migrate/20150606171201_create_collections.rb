class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :title
      t.string :description

      t.integer :patternable_id
      t.integer :patternable_type

      t.timestamps null: false
    end
    add_index :collections, [:patternable_id, :patternable_type]
  end
end
