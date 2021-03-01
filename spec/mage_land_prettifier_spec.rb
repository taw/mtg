describe "mage_land_prettifier" do
  let(:binary) { Pathname(__dir__) + "../bin/mage_land_prettifier" }
  let(:txt) { `#{binary} <#{deck_path}` }

  describe "Gruul aggro" do
    let(:deck_path) { Pathname(__dir__) + "data/jeskai_control.dck" }
    let(:expected) {
      <<~EOF
        4 [SOI:247] Nahiri, the Harbinger
        3 [WWK:133] Celestial Colonnade
        4 [CON:15] Path to Exile
        4 [M11:149] Lightning Bolt
        4 [ISD:78] Snapcaster Mage
        3 [DIS:33] Spell Snare
        4 [5DN:36] Serum Visions
        4 [EXP:22] Scalding Tarn
        1 [ROE:4] Emrakul, the Aeons Torn
        1 [EXP:6] Hallowed Fountain
        1 [M12:40] Timely Reinforcements
        2 [ISD:248] Sulfur Falls
        4 [EXP:16] Flooded Strand
        2 [EXP:12] Steam Vents
        2 [M12:63] Mana Leak
        1 [10E:61] Wrath of God
        2 [RAV:213] Lightning Helix
        1 [EXP:24] Arid Mesa
        1 [UST:215] Mountain
        1 [ISD:240] Ghost Quarter
        1 [MOR:55] Vendilion Clique
        1 [EXP:14] Sacred Foundry
        3 [TSP:48] Ancestral Vision
        2 [RAV:63] Remand
        2 [UST:213] Island
        1 [UST:212] Plains
        1 [THS:112] Anger of the Gods
        SB: 2 [DGM:135] Wear // Tear
        SB: 1 [M12:40] Timely Reinforcements
        SB: 1 [5DN:118] Engineered Explosives
        SB: 2 [OGW:59] Negate
        SB: 1 [RTR:201] Supreme Verdict
        SB: 1 [OGW:110] Goblin Dark-Dwellers
        SB: 1 [THS:112] Anger of the Gods
        SB: 1 [THS:9] Elspeth, Sun's Champion
        SB: 1 [ALA:218] Relic of Progenitus
        SB: 2 [BFZ:128] Crumble to Dust
        SB: 1 [TSP:83] Teferi, Mage of Zhalfir
        SB: 1 [BFZ:76] Dispel
      EOF
    }
    it do
      expect(txt.tr("\r", "")).to eq(expected)
    end
  end
end
