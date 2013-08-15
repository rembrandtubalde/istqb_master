require 'spec_helper'

describe "UserPages" do
  subject { page }
  
  describe "Sign up page" do
    before { visit signup_path }
    
    it "should have content 'Sign up'" do
	  should have_content('Sign up')
	end
	
	it "should have correct title" do
	  should have_title('ISTQB Master | Sign up')
	end
  
  end
  
end
