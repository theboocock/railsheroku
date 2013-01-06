# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
    before do 
        @user =  User.new(name: "Example Name", email: "User@example.com", password: "foobar", password_confirmation: "foobar" )
    end
    subject { @user }

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
   
    describe "with a pasword thats too short" do
        before { @user.password = @user.password_confirmation = "a" * 5 }
        it { should be_invalid } 
    end

    describe "return value of authenticate method" do
        before { @user.save }
        let(:found_user) { User.find_by_email(@user.email)}

        describe "With valid password" do
            it { should == found_user.authenticate(@user.password) }
        end
        describe "With invalid password" do
            let(:user_for_invalid_password) { found_user.authenticate("invalid") }
            it { should_not == user_for_invalid_password }
            specify { user_for_invalid_password.should be_false }
        end

    end

    describe "When password is not present" do
        before { @user.password  = @user.password_confirmation = " " }
        it { should_not be_valid}
    end
    describe "When password doesn't match confirmation" do
        before { @user.password_confirmation = "mismatch " }
        it { should_not be_valid }
    end
    describe "When password doesn't match confirmation" do
        before { @user.password_confirmation = nil }
        it { should_not be_valid } 
    end
    describe "When name is not present" do
        before { @user.name = " " }
        it { should_not be_valid } 
    end

    describe "When email is not present" do
        before { @user.email = " "}
        it { should_not be_valid }
    end
    describe "When name is too long " do
        before { @user.name = "a" * 51 }
        it { should_not be_valid } 
    end
    describe "When email format is valid" do
        it "Should be valid"  do
            addresses = %w[user@foo.com A@BLAD.ORG red.car@foo.jp]
            addresses.each do  |valid_address|
                @user.email = valid_address
                @user.should be_valid
            end
        end
    end
    describe "When email format is invalid" do
        it "Should be invalid" do
            addresses = %w[user@foo,com user_at_foo.org a+b@baz+baz.com]
            addresses.each do |invalid_address|
                @user.email = invalid_address
                @user.should_not be_valid
            end
        end
    end
    describe "When email address is already taken" do
        before do
               user_with_same_email = @user.dup
               user_with_same_email.email = @user.email.upcase
               user_with_same_email.save
        end
        it { should_not be_valid }
    end


end
