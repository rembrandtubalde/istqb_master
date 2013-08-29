class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :answer
      t.integer :correct_answer

      t.timestamps
    end
    add_index :attempts, [:user_id, :created_at]
  end
end
