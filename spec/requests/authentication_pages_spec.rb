require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  # basic tests
  describe "signin page" do
    before { visit signin_path }

    it "should contain Sign in text" do
      should have_content('Sign in')
    end
    
    it "should have corresponding title" do 
      should have_title('Sign in')
    end
  end
  
  # authentication test
  describe "Sign in" do
    before { visit signin_path }
    
    ## invalid credentials
    describe "with invalid credentials" do
      before { click_button "Sign in" }
      
      it "should re-load same Sign in page" do
        should have_title ('Sign in')
      end
      
      it "should display error message via flash" do
        should have_selector('div.alert.alert-error', text: 'Authentication failure!')
      end
      
      describe "after visiting another page" do
        before { click_link "Home" }
        
        it "should not have flash error message" do
          should_not have_selector('div.alert.alert-error', text: 'Authentication failure!')
        end
      end
    end
    
    ## valid credentials
    describe "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",		with: user.email.upcase
        fill_in "Password",		with: user.password
        click_button "Sign in"
      end
      
      it "should redirect to the profile page" do
        should have_title(user.name)
      end
      
      it "should enable the Profile link" do
        should have_link('Profile',		href: user_path(user))
      end
      
      it "should enable Sign out link" do
        should have_link('Sign out',		href: signout_path)
      end
      
      it "should disable Sign in link" do
        should_not have_link('Sign in',	href: signin_path)
      end
      
      describe "and sign out" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
    
  end
end
