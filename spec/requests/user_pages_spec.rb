require 'spec_helper'

describe "UserPages" do
  subject { page }
  
  # tests for index page
  describe "Index" do
  let(:user) { FactoryGirl.create(:user) }
    before do
	  visit signin_path
	  fill_in "Email",    with: user.email
	  fill_in "Password", with: user.password
	  click_button "Sign in"
	  FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end
    
    it "should have correct title" do
      should have_title('All users')
    end
    
    it "should contain 'All users' text" do
      should have_content('All users')
    end
    
    ## pagination tests
	describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    
    ## availability of delete links
    describe "delete links" do
      it "should not display delete links for simple users" do
        should_not have_link("delete")
      end
      
      ### tests for admin users
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        
        before do
          visit signin_path
		  fill_in "Email",    with: admin.email
		  fill_in "Password", with: admin.password
		  click_button "Sign in"
		  visit users_path
        end
        
        it "should have delete links next to the users" do
          should have_link('delete', href:user_path(User.first))
        end
        
        it "should be able to delete user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        
        it "should not be able to delete another admin" do
          should_not have_link('delete', href: user_path(admin))
        end
      end
    end
  end
  
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
      
      ### login after creating a user
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it "should have link to Sign out" do
          should have_link('Sign out')
        end
        
        it "should have corresponding title" do
          should have_title(user.name)
        end 
        
        it "should have Success flash message" do
          should have_selector('div.alert.alert-success', text: 'Welcome')
        end
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
   
   # edit page tests
   describe "edit" do
     let(:user) { FactoryGirl.create(:user) }
     before do 
       visit signin_path
	   fill_in "Email",    with: user.email
	   fill_in "Password", with: user.password
	   click_button "Sign in"
       visit edit_user_path(user)
     end
     
     ## page contents test
     describe "page" do
       it "should have Update your profile text" do
         should have_content("Update your profile")
       end
       
       it "should have correct title" do
         should have_title("Edit user")
       end
       
       it "should contain link to change gravatar image" do
         should have_link("change", href: 'http://gravatar.com/emails')
       end
     end
     
     ## negative tests
     describe "with invalid information" do
       before { click_button "Save changes" }
       
       it "should display an error message" do
         should have_content ("error")
       end
     end
     
     ## positive tests
     describe "with valid information" do
       let(:new_name)  { "New Name" }
       let(:new_email) { "new@example.com" }
       before do
         fill_in "Name",             with: new_name
         fill_in "Email",            with: new_email
         fill_in "Password",         with: user.password
         fill_in "Confirmation", with: user.password
         click_button "Save changes"
       end

       it "should have correct title" do
         should have_title(new_name)
       end
      
       it "should have success flash message" do
         should have_selector('div.alert.alert-success')
       end
      
       it "should have Sign out link" do
         should have_link('Sign out', href: signout_path)
       end
      
       specify "should have an updated name" do
         expect(user.reload.name).to  eq new_name
       end
      
       specify "should have an updated email" do 
         expect(user.reload.email).to eq new_email
       end
        
     end
   end
  
end
