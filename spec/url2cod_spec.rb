describe "url2cod" do
  let(:binary) { Pathname(__dir__)+"../bin/url2cod" }
  let(:run) do
    Dir.chtmpdir do |tmp_dir|
      system "ruby", "-r#{__dir__}/mock_network", binary.to_s, url or raise "Script failed"
      system "diff -r #{tmp_dir} #{__dir__}/url2cod/#{reference_dir}/" or raise "Diff failed"
    end
  end

  describe "www.wizards.com" do
    let(:url) { "http://magic.wizards.com/en/articles/archive/top-decks/evolving-mana-bases-2016-04-15" }
    let(:reference_dir) { "wizards_com" }
    it do
      run
    end
  end

  describe "SCG" do
    let(:url) { "http://old.starcitygames.com/decks/101059" }
    let(:reference_dir) { "scg" }
    it do
      run
    end
  end

  describe "mtgtop8" do
    let(:url) { "http://mtgtop8.com/event?e=11914&f=MO" }
    let(:reference_dir) { "mtgtop8" }
    it do
      run
    end
  end

  describe "mtggoldfish" do
    let(:url) { "https://www.mtggoldfish.com/archetype/niv-to-light-83149596-72ba-4d65-ba7d-1ed648eb583f" }
    let(:reference_dir) { "mtggoldfish" }
    it do
      run
    end
  end
end
