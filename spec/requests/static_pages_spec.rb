require 'spec_helper'

describe "Static pages" do

  # tests for home page
  describe "Home page" do

	it "should have the correct title" do
	  visit '/static_pages/home'
	  expect(page).to have_title('ISTQB Master | Home')
	end
	
    it "should have the content 'ISTQB Master'" do
      visit '/static_pages/home'
      expect(page).to have_content('ISTQB Master')
    end
    
  end
  
  # tests for about page
  describe "About page" do
	
	it "should have the correct title" do
	  visit '/static_pages/about'
	  expect(page).to have_title('ISTQB Master | About')
	end
	
	it "should have the content 'Dmitri Severinov'" do
		  visit '/static_pages/about'
		  expect(page).to have_content('Dmitri Severinov')
	end  
	
	it "should contain author's email" do
		  visit '/static_pages/about'
		  expect(page).to have_content('dmitry.severinov on Gmail')
	end
	
  end
end
