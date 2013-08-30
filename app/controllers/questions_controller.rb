class QuestionsController < ApplicationController
  
  before_action :signed_in_user
  before_action :admin_user
  
  
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

		
		def correct_user
		  @user = User.find(params[:id])
		  redirect_to(root_url) unless current_user?(@user)
		end
		
		def admin_user
		  redirect_to(root_url) unless current_user.is_superuser?
		end


end
