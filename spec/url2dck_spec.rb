describe "url2dck" do
  let(:binary) { Pathname(__dir__) + "../bin/url2dck" }
  let(:run) do
    Dir.chtmpdir do |tmp_dir|
      system("ruby", "-r#{__dir__}/mock_network", binary.to_s, url) || raise("Script failed")
      system("diff -r #{tmp_dir} #{__dir__}/url2dck/#{reference_dir}/") || raise("Diff failed")
    end
  end

  describe "decks.tcgplayer.com" do
    let(:url) { "https://decks.tcgplayer.com/magic/modern/meryn/simic-splendid-reclamation/1377086" }
    let(:reference_dir) { "tcgplayer" }
    it do
      run
    end
  end
end
