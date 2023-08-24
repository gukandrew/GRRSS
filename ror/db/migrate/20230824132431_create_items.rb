class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :title
      t.string :source
      t.string :source_url
      t.string :link
      t.datetime :published_at
      t.text :description
      t.references :feed, null: true, foreign_key: true

      t.timestamps
    end

    add_index :items, :title
    add_index :items, :source
    add_index :items, :source_url
    add_index :items, :published_at
    add_index :items, [:title, :source], unique: true
  end
end
