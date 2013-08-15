require 'spec_helper'

describe "Static pages" do
  subject { page }
  # tests for home page
  describe "Home page" do
	before { visit root_path }
	
	it "should have the correct title" do
	  should have_title('ISTQB Master | Home')
	end
	
    it "should have the content 'ISTQB Master'" do
      should have_content('ISTQB Master')
    end
    
  end
  
  # tests for about page
  describe "About page" do
	before { visit about_path }
	
	it "should have the correct title" do
	  should have_title('ISTQB Master | About')
	end
	
	it "should have the content 'Dmitri Severinov'" do
		  should have_content('Dmitri Severinov')
	end  
	
	it "should contain author's email" do
		  should have_content('dmitry.severinov on Gmail')
	end
	
  end
end
