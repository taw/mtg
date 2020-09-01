describe "analyze_deck_colors" do
  let(:binary) { Pathname(__dir__) + "../bin/cleanup_decklist" }
  let(:cleaned_up_decklist) { `#{binary} <#{deck_path}` }

  describe "Gruul aggro" do
    let(:deck_path) { Pathname(__dir__) + "data/gruul_aggro.txt" }
    let(:expected) {
      <<~EOF
        12 Mountain
        4 Stomping Ground
        4 Rootbound Crag
        4 Boros Reckoner
        4 Burning-Tree Emissary
        4 Flinthoof Boar
        4 Hellrider
        4 Lightning Mauler
        4 Rakdos Cackler
        4 Stromkirk Noble
        3 Ghor-Clan Rampager
        4 Brimstone Volley
        4 Searing Spear
        1 Pillar of Flame
        SB: 2 Blasphemous Act
        SB: 3 Grafdigger's Cage
        SB: 1 Mizzium Mortars
        SB: 4 Skullcrack
        SB: 2 Traitorous Blood
        SB: 3 Volcanic Strength
      EOF
    }
    it do
      expect(cleaned_up_decklist).to eq(expected)
    end
  end

  describe "UWR flash" do
    let(:deck_path) { Pathname(__dir__) + "data/uwr_flash.txt" }
    let(:expected) {
      <<~EOF
        4 Augur of Bolas
        3 Snapcaster Mage
        4 Restoration Angel
        2 Thundermaw Hellkite
        3 Pillar of Flame
        4 Azorius Charm
        2 Think Twice
        2 Counterflux
        1 Rewind
        2 Supreme Verdict
        2 Warleader's Helix
        1 Turn // Burn
        3 Sphinx's Revelation
        2 Syncopate
        4 Hallowed Fountain
        4 Steam Vents
        2 Sacred Foundry
        4 Glacial Fortress
        4 Sulfur Falls
        3 Clifftop Retreat
        1 Island
        2 Cavern of Souls
        1 Moorland Haunt
        SB: 1 Celestial Flare
        SB: 2 Counterflux
        SB: 1 Detention Sphere
        SB: 2 Izzet Staticaster
        SB: 3 Rhox Faithmender
        SB: 1 Supreme Verdict
        SB: 3 Archangel of Thune
        SB: 2 AEtherling
      EOF
    }
    it do
      expect(cleaned_up_decklist).to eq(expected)
    end
  end
end
