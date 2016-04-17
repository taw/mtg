require_relative "spec_helper"

describe "cod2txt" do
  let(:binary) { Pathname(__dir__)+"../bin/cod2txt" }
  let(:txt) { `#{binary} <#{deck_path}` }
  describe "Gruul aggro" do
    let(:deck_path) { Pathname(__dir__)+"data/gruul_aggro.cod" }
    let(:expected) {
      """
      // NAME: Gruul Aggro
      // COMMENTS: Gruul Smash!
      4 Boros Reckoner
      4 Brimstone Volley
      4 Burning-Tree Emissary
      4 Flinthoof Boar
      3 Ghor-Clan Rampager
      4 Hellrider
      4 Lightning Mauler
      12 Mountain
      1 Pillar of Flame
      4 Rakdos Cackler
      4 Rootbound Crag
      4 Searing Spear
      4 Stomping Ground
      4 Stromkirk Noble

      Sideboard
      2 Blasphemous Act
      3 Grafdigger's Cage
      1 Mizzium Mortars
      4 Skullcrack
      2 Traitorous Blood
      3 Volcanic Strength
      """
    }
    it do
      expect(txt.strip.gsub(/^ +/, "")).to eq(expected.strip.gsub(/^ +/, ""))
    end
  end
end
