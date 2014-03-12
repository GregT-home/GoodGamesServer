require 'pry'
class Spinach::Features::SignIn < Spinach::FeatureSteps
  step 'a user visits the sign-in page' do
    visit new_user_session_path
  end

  step 'they submit invalid sign-in information' do
    click_button "Sign in"
  end

  step 'they see an error message' do
    expect(find ".alert").to have_content('Invalid')
  end

  step 'has an account' do
    @user = User.create(email: "user@example.com",
                      password: "secretpw", password_confirmation: "secretpw")
  end

  step 'provides valid sign-in credentials' do
    fill_in "Email",    with: @user.email
    fill_in "Password", with: @user.password
    click_button "Sign in"
  end

  step 'they see the GoFishy game screen' do
    pending ("we need to define success for this test.")
#    expect(page).to have_title(@user.name)
  end
end
