# webmock/rspec

require_relative "spec_helper"
require "tmpdir"
require "pry"

describe "url2cod" do
  let(:binary) { Pathname(__dir__)+"../bin/url2cod" }

  describe "www.wizards.com" do
    let(:url) { "http://magic.wizards.com/en/articles/archive/top-decks/evolving-mana-bases-2016-04-15" }
    it do
      Dir.chtmpdir do |tmp_dir|
        system "ruby", "-r#{__dir__}/mock_network", binary.to_s, url
        system "diff -r #{tmp_dir} #{__dir__}/url2cod/wizards_com"
      end
    end
  end

  describe "SCG" do
    let(:url) { "http://sales.starcitygames.com/deckdatabase/displaydeck.php?DeckID=101059" }
    it do
      Dir.chtmpdir do |tmp_dir|
        system "ruby", "-r#{__dir__}/mock_network", binary.to_s, url
        system "diff -r #{tmp_dir} #{__dir__}/url2cod/scg"
      end
    end
  end
end
