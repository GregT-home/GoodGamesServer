require 'pry'
class Spinach::Features::SignIn < Spinach::FeatureSteps
  step 'a registered user visits the sign-in page' do
    @user = User.create(email: "user@example.com",
                      password: "secretpw", password_confirmation: "secretpw")
    visit new_user_session_path
  end

  step 'they submit invalid sign-in information' do
    click_button "Sign in"
  end

  step 'they see an error message' do
    expect(find ".alert").to have_content('Invalid')
  end

  step 'they provide valid sign-in credentials' do
    fill_in "Email",    with: @user.email
    fill_in "Password", with: @user.password
    click_button "Sign in"
  end

  step 'they see the Join GoFishy game screen' do
    save_and_open_page("tmp-pagedump.html") if (!page.has_text?("Join GoFishy Game")) 
    expect(page).to have_text("Join GoFishy Game")
  end
end
