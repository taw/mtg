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
end
