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
  end
end
