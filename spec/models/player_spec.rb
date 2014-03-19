describe Player, "Player communications" do
  before :each do
    @player = Player.new(0, "No Name")
  end

  it ".new creates an empty human player" do
    @player.number.should eql 0
    expect(@player.name).to eql "No Name"
    expect(@player.robot?).to be_false
  end

  it "#make_robot makes the player a robot" do
    expect(@player.robot?).to be_false
    @player.make_robot
    expect(@player.robot?).to be_true
  end

  it "#robot? is true if the player is a robot" do
    @player.make_robot
    expect(@player.robot?).to be_true
  end

  it "#robot? is false if the player is not a robot" do
    expect(@player.robot?).to be_false
  end

  it ".tell, sends a message for the player" do
    @player.tell("message one")
    @player.tell("message two")

    @player.messages?.should be_true
  end

  it ".messages, returns an array of outstanding messages for the player" do
    @player.tell("message one")
    @player.tell("message two")

    messages = @player.messages(false)

    messages[0].should eql "message one"
    messages[1].should eql "message two"
    messages[2].should eql nil

    @player.messages?.should be_true
  end

  it ".messages, returns the array of outstanding messages for the player, and deletes them" do
    @player.tell("message one")

    messages = @player.messages(true)

    messages[0].should eql "message one"
    messages[1].should eql nil

    @player.messages?.should be_false
  end
end
