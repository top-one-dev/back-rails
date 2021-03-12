class CreateCmessages < ActiveRecord::Migration[5.2]
  def change
    create_table :cmessages do |t|
      t.text :content
      t.string :attach
      t.references :conversation, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
