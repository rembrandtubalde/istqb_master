class QuestionsController < ApplicationController
  
  before_action :signed_in_user
  
  
  def show
    @question = Question.find(params[:id])
  end
  
  
  before_action :admin_user
  
  def destroy
      Question.find(params[:id]).destroy
      flash[:success] = "Question deleted."
      redirect_to users_url
  end
  
  def edit
    @question = Question.find(params[:id])
  end
  
  def update
	@question = Question.find(params[:id])
	if @question.update_attributes(question_params)
	    flash[:success] = "Question updated"
		redirect_to @question
	  else
	    render 'edit'
	  end
	end
  
  def import
  end
     
  def load_csv
    Question.save_file(params[:file])
    redirect_to import_path, notice: "Done!"
  end
  
  def download
    send_file 'public/example/example.csv', type: "text/csv", x_sendfile: true
  end
  
  private

		def question_params
		  params.require(:question).permit(:question, :option_one, :option_two,
									   :option_three, :option_four, :correct_answer,
									   :certificate_type)
		end
		
		def correct_user
		  @user = User.find(params[:id])
		  redirect_to(root_url) unless current_user?(@user)
		end
		
		def admin_user
		  redirect_to(root_url) unless current_user.is_superuser?
		end


end
