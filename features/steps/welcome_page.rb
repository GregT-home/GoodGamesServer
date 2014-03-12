class Spinach::Features::WelcomePage < Spinach::FeatureSteps
  step 'a user visits the home page' do
    visit root_path
  end

  step 'they should see a descriptive page' do
    expect(page).to have_content("Welcome to Good Games")
    expect(page).to have_title("Good Games")
  end

  step 'be able to sign-in' do
    expect(find ".main-choices").to have_link("Sign In", href: user_session_path)
  end
end
