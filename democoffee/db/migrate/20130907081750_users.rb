class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :email
      t.boolean :status
      t.integer :value_level
      t.string  :qr_code_uid
      t.string  :qr_code_name

      t.timestamps
    end
  end
end
