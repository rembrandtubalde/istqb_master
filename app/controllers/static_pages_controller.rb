class StaticPagesController < ApplicationController
  def home
  end

  def about
  end
  
  def home
    @attempt = current_user.attempts.build if signed_in?
  end
end
