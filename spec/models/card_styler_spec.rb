require 'spec_helper'

describe CardStyler do
  before :all do
    @card = Card.new("Q", "H")
  end

  describe "#new: creates image strings based on deck styles" do
    it "#new: defaults to 'standard'" do
      card_styler = CardStyler.new
      expect(card_styler.image_name(@card)).to eql("standard/h_q.png")
    end

    it "#new: can be used to change the deck style" do
      card_styler = CardStyler.new("shapes1")
      expect(card_styler.image_name(@card)).to eql("shapes1/c_flower.png")
    end

    it "#new: unrecognized styles map to 'standard'" do
      card_styler = CardStyler.new("weird_and_wacky")
      expect(card_styler.image_name(@card)).to eql("standard/h_q.png")
    end
  end

  describe "#image_name: creates a standardized image name based on deck styles" do
    it "#image_name: defaults to a standard descriptive name" do
      card_styler = CardStyler.new
      expect(card_styler.image_name(@card)).to eql("standard/h_q.png")
    end

    it "adjusts name to fit the chosen style" do
      card_styler = CardStyler.new("shapes1")
      expect(card_styler.image_name(@card)).to eql("shapes1/c_flower.png")
    end
  end # card_styler.text_name tests

  describe "#text_name: creates alt description strings based on deck styles" do
    it "#text_name: defaults to a standard descriptive name" do
      card_styler = CardStyler.new
      expect(card_styler.text_name(@card)).to eql("Q-of-H")
    end

    it "#text_name: adjusts name to fit the chosen style" do
      card_styler = CardStyler.new("shapes1")
      expect(card_styler.text_name(@card)).to eql("FLOWER-of-C")
    end
  end # card_styler.text_name tests

  describe "#rank: converts an internal card code to an external card rank based on deck styles" do
    it "#rank: defaults to a standard descriptive name" do
      card_styler = CardStyler.new
      expect(card_styler.rank(@card.rank)).to eql("Q")
    end

    it "#rank: adjusts name to fit the chosen style" do
      card_styler = CardStyler.new("shapes1")
      expect(card_styler.rank(@card.rank)).to eql("FLOWER")
    end
  end # card_styler.rank tests

  describe "#rank_option_list: creates an array with internal card code and external card name based on deck styles" do
    it "#rank_option_list: defaults to a standard descriptive name" do
      card_styler = CardStyler.new
      expect(card_styler.rank_option_list(@card)).to eql(["Q", "Q"])
    end

    it "#rank_option_list: adjusts name to fit the chosen style" do
      card_styler = CardStyler.new("shapes1")
      expect(card_styler.rank_option_list(@card)).to eql(["FLOWER", "Q"])
    end
  end # card_styler.rank_option_list tests

end # DeckHelper
