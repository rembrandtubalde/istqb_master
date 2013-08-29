class Attempt < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence:true
  validates :question_id, presence:true
  validates :answer, presence:true, :inclusion => { :in => [1,2,3,4] }
  validates :correct_answer, presence:true
end
