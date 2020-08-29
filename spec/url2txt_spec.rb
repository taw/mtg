describe "url2txt" do
  let(:binary) { Pathname(__dir__)+"../bin/url2txt" }
  let(:run) do
    Dir.chtmpdir do |tmp_dir|
      system "ruby", "-r#{__dir__}/mock_network", binary.to_s, url or raise "Script failed"
      system "diff -r #{tmp_dir} #{__dir__}/url2txt/#{reference_dir}/" or raise "Diff failed"
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

  describe "www.wizards.com" do
    let(:url) { "https://magic.wizards.com/en/articles/archive/news/commander-2016-edition-decklists-2016-10-28" }
    let(:reference_dir) { "wizards" }
    it do
      run
    end
  end
end
