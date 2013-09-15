class UsersController < ApplicationController
	
	before_action :signed_in_user,	only: [:edit, :update, :destroy]
	before_action :correct_user,	only: [:show, :destroy, :edit, :update]
  before_action :admin_user, only: [:index]
	
	def new
	  @user = User.new
	end
	
	def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
	
	def index
	  @users = User.paginate(page: params[:page])
	end
	  
	def show
	  @user = User.find(params[:id])
	  @attempts = @user.attempts.paginate(page: params[:page], :per_page => 25)
    if !@user.attempts.empty?
      @fa =  @user.attempts.collect do |x|
          next if x.answer == x.correct_answer
          x
      end.compact!
      @failed_attempts = @fa.paginate(page: params[:page], per_page: 25)
    end
    #@failed_attempts = @fa.paginate(page: params[:page], per_page: 25)
  end
	  
	def edit
	end
	
	def update
	  if @user.update_attributes(user_params)
	    flash[:success] = "Profile updated"
		sign_in @user
		redirect_to @user
	  else
	    render 'edit'
	  end
	end

	def create
		@user = User.new(user_params)
		if @user.save
		  sign_in @user
		  flash[:success] = "Welcome to the Sample App!"
		  redirect_to @user
		else
		  render 'new'
		end
	end
	
	def clear_history
	   @user = current_user
	   @user.attempts.delete_all
	   redirect_to @user
	end
	  

	  private

		def user_params
		  params.require(:user).permit(:name, :email, :password,
									   :password_confirmation,
									   :certificate_type)
		end
			
		def correct_user
		  @user = User.find(params[:id])
		  if @user
        redirect_to(current_user) unless current_user?(@user)
      else
        redirect_to(root_url)
      end
		end
		
		def admin_user
		  if signed_in?
        redirect_to(current_user) unless current_user.is_superuser?
      else
        redirect_to(root_url)
      end
		end
	end
