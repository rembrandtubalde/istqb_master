require 'spec_helper'

describe User do
  
  before { @user = User.new(name: "Test User", email: "testuser@example.com", password: "password", password_confirmation: "password" ) }
  
  subject { @user }
  
  # basic tests for user fields presence
  it "should respond to :name property" do
    should respond_to(:name)
  end
  
  it "should respond to :email property" do
    should respond_to(:email)
  end
  
  it "should respond to :is_superuser property" do
    should respond_to(:is_superuser)
  end
  
  it "should respond to :certificate_type property" do
    should respond_to(:certificate_type)
  end
  
  it "should respond to :password_digest property" do
	should respond_to(:password_digest)
  end
  
  it "should respond to :password property" do
	should respond_to(:password)
  end
  
  it "should respond to :password_confirmation property" do
	should respond_to(:password_confirmation)
  end
  
  it "should respond to :authenticate property" do
	should respond_to(:authenticate)
  end
  
  it "should be valid" do
    should be_valid
  end
  
  
  # value validations 
  describe "when name is empty" do
	before { @user.name = "" }
	
	it "should not be valid" do
	  should_not be_valid
	end
  end
  
  describe "when email is empty" do
    before { @user.email = "" }
    
    it "should not be valid" do
	  should_not be_valid
	end
  end
  
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    
     it "should not be valid" do
	  should_not be_valid
	end    
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end             
    end
  end
  
  describe "when email format is correct" do
    it "should be invalid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end             
    end
  end
  
  describe "when email already exists" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it "should not be valid" do
      should_not be_valid
    end
  end
  
  describe "when password is empty" do
    before do
      @user = User.new(name: "Test User", email: "testuser@example.com", password: "", password_confirmation: "pass")
    end
    it "should not be valid" do
      should_not be_valid
    end
  end
  
  describe "when password_confirmation does not match password" do
    before do
      @user.password_confirmation = "some_random_stuff"
    end
    it "should not be valid" do
      should_not be_valid
    end
  end
  
  # password tests
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it "should not be valid" do
      should_not be_valid
    end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
end
