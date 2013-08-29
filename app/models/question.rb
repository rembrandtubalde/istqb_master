class Question < ActiveRecord::Base
  has_many :attempts, dependent: :destroy
  validates :question, presence:true
  validates :option_one, presence:true
  validates :option_two, presence:true
  validates :correct_answer, presence:true, :inclusion => { :in => [1,2,3,4] }
end
