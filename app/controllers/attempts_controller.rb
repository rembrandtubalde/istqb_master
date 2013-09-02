class AttemptsController < ApplicationController
  include StaticPagesHelper
  before_action :signed_in_user
  
  before_action :correct_user


  def create
    @attempt = current_user.attempts.build(attempt_params)
    @attempt.question_id = current_question.id
    @attempt.correct_answer = current_question.correct_answer
    if @attempt.save
      if @attempt.answer == @attempt.correct_answer
        flash[:success] = "Boom! Headshot!"
      else
        flash[:error] = "That was a close one... The correct one was #{@attempt.correct_answer}"
      end
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end
  

  
  private

    def attempt_params
      params.require(:attempt).permit(:answer,:question_id,:correct_answer)
    end
end
