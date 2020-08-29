describe "url2txt" do
  let(:binary) { Pathname(__dir__)+"../bin/url2txt" }
  let(:run) do
    Dir.chtmpdir do |tmp_dir|
      system "ruby", "-r#{__dir__}/mock_network", binary.to_s, url or raise "Script failed"
      system "diff -r #{tmp_dir} #{__dir__}/url2txt/#{reference_dir}/" or raise "Diff failed"
    end
  end

  describe "mtgtop8" do
    let(:url) { "https://www.mtgtop8.com/event?e=27053&d=412626&f=EDH" }
    let(:reference_dir) { "mtgtop8" }
    it do
      run
    end
  end
end
