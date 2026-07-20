describe "txt2cod" do
  let(:binary) { Pathname(__dir__) + "../bin/txt2txt" }
  let(:txt) { `#{binary} <#{deck_path}` }

  describe "Uro Commander deck" do
    let(:deck_path) { Pathname(__dir__) + "data/uro_titan_of_ffs.dck" }
    let(:expected) {
      <<~EOF
        // NAME: Uro, Titan of FFS
        COMMANDER: 1 Uro, Titan of Nature's Wrath
        1 Jace, Wielder of Mysteries
        1 Laboratory Maniac
        1 Marit Lage's Slumber
        1 Scrying Sheets
        46 Snow-Covered Forest
        49 Snow-Covered Island

        Sideboard
        1 Courser of Kruphix
        1 Hedron Crab
        1 Oracle of Mul Daya
        1 Roil Elemental
        1 Tatyova, Benthic Druid
        1 Thassa's Oracle
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  # https://www.mtgsalvation.com/forums/the-game/modern/established-modern/aggro-tempo/782962-burn
  describe "deck using 4x counts" do
    let(:deck_path) { Pathname(__dir__) + "data/burn_4x.txt" }
    let(:expected) {
      <<~EOF
        // NAME: RWg Burn
        4 Arid Mesa
        4 Inspiring Vantage
        3 Mountain
        2 Sacred Foundry
        3 Scalding Tarn
        1 Stomping Ground
        3 Wooded Foothills
        4 Eidolon of the Great Revel
        4 Goblin Guide
        4 Monastery Swiftspear
        4 Boros Charm
        4 Lava Spike
        4 Lightning Bolt
        4 Lightning Helix
        4 Rift Bolt
        4 Searing Blaze
        4 Skullcrack

        Sideboard
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end
end
