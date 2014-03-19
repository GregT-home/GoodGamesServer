require 'spec_helper'

describe CardDecorator do
  before :all do
    @card = Card.new("Q", "H")
  end

  describe "#new and #card_map_image: creates image strings based on deck styles" do
    it "#new: defaults to 'standard'" do
      card_face = CardDecorator.new
      expect(card_face.image(@card)).to eql("standard/h_q.png")
    end

    it "#new: can be used to change the deck style" do
      card_face = CardDecorator.new(:shapes1)
      expect(card_face.image(@card)).to eql("shapes1/c_flower.png")
    end

    it "#new: unrecognized styles map to 'standard'" do
      card_face = CardDecorator.new(:weird_and_wacky)
      expect(card_face.image(@card)).to eql("standard/h_q.png")
    end
  end

  describe "#card_face.alt: creates alt description strings based on deck styles" do
    it "#card_face.alt: defaults to a standard descriptive name" do
      card_face = CardDecorator.new
      expect(card_face.alt(@card)).to eql("q-of-h")
    end

    it "#card_face.alt: adjusts name to fit the chosen style" do
      card_face = CardDecorator.new(:shapes1)
      expect(card_face.alt(@card)).to eql("flower-of-c")
    end
  end # card_face.alt tests
end # DeckHelper
