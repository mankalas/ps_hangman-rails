require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:name) { "Chiche" }
  let(:color) { "#fabecc" }
  let(:player) { Player.new(name: name, color: color) }

  describe "validation" do
    describe "#name" do
      context "rejects" do
        it "empty word" do
          expect{ player.name = "" }.to change{ player.valid? }.from(true).to(false)
        end

        it "nil" do
          expect{ player.name = nil }.to change{ player.valid? }.from(true).to(false)
        end
      end
    end

    describe "#color" do
      it "rejects anything not formatted like a hex color" do
        expect{ player.color = "fabecc" }.to change{ player.valid? }.from(true).to(false)
        # expect{ player.color = "" }.to change{ player.valid? }.from(true).to(false)
        # expect{ player.color = "123456" }.to change{ player.valid? }.from(true).to(false)
        # expect{ player.color = "green" }.to change{ player.valid? }.from(true).to(false)
        # expect{ player.color = 123456 }.to change{ player.valid? }.from(true).to(false)
      end

      it "accepts a hex formatted color" do
        expect{ player.color = "#fabec1" }.not_to change{ player.valid? }
#        expect{ player.color = "#000001" }.to change{ player.valid? }.from(true).to(false)
      end
    end
  end
end
