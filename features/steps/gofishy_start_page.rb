class Spinach::Features::GofishyStartPage < Spinach::FeatureSteps
  I18n.enforce_available_locales = false  # avoid deprecation warning

  step 'a GoFishy Player' do
    @user = User.create(email: "whoami@example.com",
                        password: "secretpw", password_confirmation: "secretpw")
    visit new_user_session_path
  end

  step 'they sign-in' do
    fill_in "Email",    with: @user.email
    fill_in "Password", with: @user.password
    click_button "Sign in"
  end

  step 'they will see the Join GoFishy Page' do
    expect(page).to have_text("Join GoFishy Game")
  end

  step 'they set the number of human players' do
    within("#number-of-humans") do
      find("option[value='1']").click
    end
  end

  step 'they set the number of robot players' do
    within("#number-of-robots") do
      find("option[value='3']").click
    end
  end

  step 'they set the style of cards to use' do
    within("#card-style") do
      find("option[value='fancy']").click
    end
  end

  step "they click on the Go Play button" do
    click_button "Go Play"
  end

  step 'they see the GoFishy game play page' do
    expect(page).to have_css "section.game-area"
  end

  step 'the History Area with messages about the Last Round' do
    expect(find ".history-area").to have_css "h2", text: "Last Round"
    expect(find(".history-area").text).to match(/It is your turn/)
  end

  step 'the Action Area that shows who to ask for what cards' do
    within(".action-area") do
      expect(page).to have_css "h2", text: "Actions you can take"
      expect(page).to have_selector "form.action"
      expect(page).to have_selector "select#opponents"
      expect(page).to have_selector "select#cards"
      # not sure how to identify an input field with value of "Ask" and type of "submit"
      #      expect(page).to have_css "input", count: 1
    end
  end

  step 'the Card Area showing their cards' do
    within(".cards-area") do
      expect(page).to have_css "h2", text: "Your Cards:"
      expect(page).to have_css "img", between: 5..7
    end
  end

  step 'the Books Area showing their books' do
    expect(find ".books-area").to have_css "h3", text: "Your Books"
    expect(find ".books-area").not_to have_css "img"
  end

  step 'the Status Area showing whose turn it is' do
    expect(find ".status-area").to have_css "h2", text: "Game Status"
    expect((find ".turn").text).to  match(/It is .*'s turn/)
    end

  step 'the Status Area showing how many cards the pond has' do
    expect((find ".pond").text).to  match(/Pond has \d+ cards./)
  end

  step 'the Status Area showing the status of players' do
    expect((find ".status").text).to  match(/.* has \d+ cards and has made \d+ books.*[You].*/)
  end
end
