class CreateGalleries < ActiveRecord::Migration[5.2]
  def change
    create_table :galleries do |t|
      t.string :src
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
