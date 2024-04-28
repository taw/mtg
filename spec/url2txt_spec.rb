describe "url2txt" do
  let(:binary) { Pathname(__dir__) + "../bin/url2txt" }
  let(:run) do
    Dir.chtmpdir do |tmp_dir|
      system("ruby", "-r#{__dir__}/mock_network", binary.to_s, url) || raise("Script failed")
      system("diff -r #{tmp_dir} #{__dir__}/url2txt/#{reference_dir}/") || raise("Diff failed")
    end
  end

  describe "mtgtop8 - commander (goes into cmd)" do
    let(:url) { "https://www.mtgtop8.com/event?e=27053&d=412626&f=EDH" }
    let(:reference_dir) { "mtgtop8" }
    it do
      run
    end
  end

  describe "mtggoldfish - companion (goes into sideboard)" do
    let(:url) { "https://www.mtggoldfish.com/archetype/niv-to-light-83149596-72ba-4d65-ba7d-1ed648eb583f" }
    let(:reference_dir) { "mtggoldfish_companion" }
    it do
      run
    end
  end

  describe "mtggoldfish - commander (goes into cmd)" do
    let(:url) { "https://www.mtggoldfish.com/archetype/brawl-rin-and-seri-inseparable-grn" }
    let(:reference_dir) { "mtggoldfish_commander" }
    it do
      run
    end
  end

  describe "www.wizards.com - old" do
    let(:url) { "https://magic.wizards.com/en/articles/archive/news/commander-2016-edition-decklists-2016-10-28" }
    let(:reference_dir) { "wizards" }
    it do
      run
    end
  end

  describe "www.wizards.com - new" do
    let(:url) { "https://magic.wizards.com/en/news/announcements/starter-commander-decks-decklists-2022-10-20" }
    let(:reference_dir) { "wizards2" }
    it do
      run
    end
  end

  describe "www.wizards.com - new with sb" do
    let(:url) { "https://magic.wizards.com/en/articles/archive/news/pioneer-challenger-decks-2021-08-24" }
    let(:reference_dir) { "wizards3" }
    it do
      run
    end
  end

  describe "decks.tcgplayer.com" do
    let(:url) { "https://decks.tcgplayer.com/magic/modern/meryn/simic-splendid-reclamation/1377086" }
    let(:reference_dir) { "tcgplayer" }
    it do
      run
    end
  end

  describe "sld" do
    let(:url) { "https://secretlair.wizards.com/uk/product/928759/artist-series-rovina-cai" }
    let(:reference_dir) { "sld" }
    it do
      run
    end
  end

  describe "sld foil" do
    let(:url) { "https://secretlair.wizards.com/uk/product/928756/diabolical-dioramas-foil-edition" }
    let(:reference_dir) { "sld_foil" }
    it do
      run
    end
  end
end
