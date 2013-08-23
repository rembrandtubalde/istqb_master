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
		  #if options[:no_capybara]
			## Sign in when not using Capybara.
			#remember_token = User.new_remember_token
			#cookies[:remember_token] = remember_token
			#user.update_attribute(:remember_token, User.encrypt(remember_token))
		  #else
			visit signin_path
			fill_in "Email",    with: user.email
			fill_in "Password", with: user.password
			click_button "Sign in"
		  #end
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
      
      it "should enable Settings link" do
        should have_link('Settings',		href: edit_user_path(user))
      end
      
      it "should enable Users link" do
        should have_link('Users', 			href: users_path)
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
  
  # authorization tests
  describe "authorization" do
    
    ## tests for users who are not signed in
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      ### test for friendly redirect
      describe "when attempting to visit a protected page" do
       before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end
      
      ### test for non-signed in user      
      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it "should redirect to the Sign in page" do
            should have_title('Sign in')
          end  
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify "should redirect to the Sign in page" do 
            expect(response).to redirect_to(signin_path)
          end
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          it "should redirect to sign in page" do
            should have_title('Sign in')
          end
        end
       
      end
    end
    
    ## permissions for non-authorized users
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before do
        remember_token = User.new_remember_token
	    cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
      end
      
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it "should not let the user see the page" do
          should_not have_title('Edit user')
        end
      end
      
      describe "submitting PATCH request to Users#update action" do
        before { patch user_path(wrong_user) }
        
        specify "should redirect to the home page" do
          expect(response).to redirect_to(root_url)
        end
      end
    end 
  
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before do 
        #remember_token = User.new_remember_token
	    #cookies[:remember_token] = remember_token
		#non_admin.update_attribute(:remember_token, User.encrypt(remember_token))
		visit signin_path
		fill_in "Email",    with: non_admin.email
		fill_in "Password", with: non_admin.password
		click_button "Sign in"
      end

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(signin_path) }
      end
    end  
    
  end
end
