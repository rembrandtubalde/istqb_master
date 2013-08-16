class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :is_superuser
      t.string :certificate_type
      
      t.timestamps
    end
  end
end
