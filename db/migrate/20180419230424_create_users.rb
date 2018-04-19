class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end
