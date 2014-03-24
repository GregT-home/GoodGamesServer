class Spinach::Features::WelcomePage < Spinach::FeatureSteps
  step 'a user visits the home page' do
    visit root_path
  end

  step 'they should see a descriptive page' do
    expect(page).to have_content("Welcome to Good Games")
    expect(page).to have_title("Good Games")
  end

  step 'they should see a navigation bar' do
    expect(page).to have_css('nav')
  end

  step 'it contains a Home link' do
    expect(find ".navbar-nav").to have_link("Home", href: root_path)
  end

  step 'a Sign in link' do
    expect(find ".navbar-nav").to have_link("Sign in", href: new_user_session_path)
  end

  step 'a Help Link' do
    expect(find ".navbar-nav").to have_link("Help", href: "#tbi")
  end

  step 'does not contain a Play Link' do
    expect(find ".navbar-nav").not_to have_link("Play")
  end

 step 'they should see a welcome message' do
    expect(page).to have_selector "h1#main-choices-title", text: "Welcome to Good Games"
  end

  step 'a choice to Sign up' do
    expect(find ".main-choices").to have_link("Sign up", href: new_user_registration_path)
  end

  step 'a choice to Sign in' do
    expect(find ".main-choices").to have_link("Sign in", href: new_user_session_path)
  end
end
