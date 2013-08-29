class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.text :option_one
      t.text :option_two
      t.text :option_three
      t.text :option_four
      t.integer :correct_answer
      t.string :certificate_type, :default => "CTFL"

      t.timestamps
    end
    add_index :questions, :id
  end
end
