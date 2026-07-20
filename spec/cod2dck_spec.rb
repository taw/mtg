describe "cod2dck" do
  let(:binary) { Pathname(__dir__) + "../bin/cod2dck" }
  let(:txt) { `#{binary} <#{deck_path}` }
  describe "Gruul aggro" do
    let(:deck_path) { Pathname(__dir__) + "data/gruul_aggro.cod" }
    let(:expected) {
      <<~EOF
        4 [GTC:215] Boros Reckoner
        4 [ISD:132] Brimstone Volley
        4 [GTC:216] Burning-Tree Emissary
        4 [M13:171] Flinthoof Boar
        3 [GTC:167] Ghor-Clan Rampager
        4 [DKA:93] Hellrider
        4 [AVR:144] Lightning Mauler
        12 [UST:215] Mountain
        1 [AVR:149] Pillar of Flame
        4 [RTR:220] Rakdos Cackler
        4 [XLN:256] Rootbound Crag
        4 [M13:147] Searing Spear
        4 [EXP:9] Stomping Ground
        4 [FDN:632] Stromkirk Noble
        SB: 2 [ISD:130] Blasphemous Act
        SB: 3 [M20:227] Grafdigger's Cage
        SB: 1 [RTR:101] Mizzium Mortars
        SB: 4 [GTC:106] Skullcrack
        SB: 2 [ISD:166] Traitorous Blood
        SB: 3 [M13:155] Volcanic Strength
      EOF
    }
    it do
      expect(txt).to eq(expected)
    end
  end

  describe "folder mode" do
    it "converts .cod files and skips everything else" do
      Dir.chtmpdir do |dir|
        input = Pathname(dir) + "in"
        output = Pathname(dir) + "out"
        input.mkpath
        (input + "gruul_aggro.cod").write((Pathname(__dir__) + "data/gruul_aggro.cod").read)
        (input + ".DS_Store").write("junk")
        (input + "README").write("not a deck")
        expect(system("#{binary} #{input} #{output}", out: File::NULL, err: File::NULL)).to eq(true)
        expect(output.children.map{|p| p.basename.to_s}.sort).to eq(["gruul_aggro.dck"])
      end
    end
  end
end
