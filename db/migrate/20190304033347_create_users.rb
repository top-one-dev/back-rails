class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :address
      t.string :tagline
      t.text :description
      t.string :skills
      t.string :avatar

      t.timestamps
    end
  end
end
