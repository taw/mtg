describe "analyze_deck_colors" do
  let(:binary) { Pathname(__dir__)+"../bin/analyze_deck_colors" }
  let(:colors) { `#{binary} <#{deck_path}`.chomp }
  describe "Gruul aggro" do
    let(:deck_path) { Pathname(__dir__)+"data/gruul_aggro.txt" }
    it do
      expect(colors).to eq("rg")
    end
  end

  describe "UWR flash" do
    let(:deck_path) { Pathname(__dir__)+"data/uwr_flash.txt" }
    it do
      expect(colors).to eq("wur")
    end
  end

  describe "UR Eldrazi" do
    let(:deck_path) { Pathname(__dir__)+"data/blue_red_eldrazi.txt" }
    it do
      # Black here is mostly theoretical, but it's correct
      expect(colors).to eq("ubrc")
    end
  end
end
