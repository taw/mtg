describe "cod2dck" do
  let(:binary) { Pathname(__dir__)+"../bin/cod2dck" }
  let(:txt) { `#{binary} <#{deck_path}` }
  describe "Gruul aggro" do
    let(:deck_path) { Pathname(__dir__)+"data/gruul_aggro.cod" }
    let(:expected) {
      """
      4 [GTC:215] Boros Reckoner
      4 [ISD:132] Brimstone Volley
      4 [GTC:216] Burning-Tree Emissary
      4 [M13:171] Flinthoof Boar
      3 [GTC:167] Ghor-Clan Rampager
      4 [DKA:93] Hellrider
      4 [AVR:144] Lightning Mauler
      12 [UNH:139] Mountain
      1 [FNMP:150] Pillar of Flame
      4 [RTR:220] Rakdos Cackler
      4 [PDS:32] Rootbound Crag
      4 [M13:147] Searing Spear
      4 [GTC:247] Stomping Ground
      4 [ISD:164] Stromkirk Noble
      SB: 2 [ISD:130] Blasphemous Act
      SB: 3 [DKA:149] Grafdigger's Cage
      SB: 1 [RTR:101] Mizzium Mortars
      SB: 4 [GTC:106] Skullcrack
      SB: 2 [ISD:166] Traitorous Blood
      SB: 3 [M13:155] Volcanic Strength
      """
    }
    it do
      expect(txt.strip.gsub(/^ +/, "")).to eq(expected.strip.gsub(/^ +/, ""))
    end
  end
end
