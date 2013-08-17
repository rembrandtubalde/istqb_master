require 'spec_helper'

describe "UserPages" do
  subject { page }
  
  # signup page tests
  describe "Sign up page" do
    before { visit signup_path }
    
    it "should have content 'Sign up'" do
	  should have_content('Sign up')
	end
	
	it "should have correct title" do
	  should have_title('ISTQB Master | Sign up')
	end
  end
  
  # signup process
  describe "signup" do

    before { visit signup_path }
    let(:submit) { "Create my account" }
	
	## negative
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
	
	## positive
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
        #fill_in "Certificate type", with: "CTFL"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
  
  #profile page tests
  describe "User profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it "should contain user's name" do
      should have_content(user.name)
    end
    
    it "should have title containing user's name" do
      should have_title(user.name)
    end
   end
  
end
