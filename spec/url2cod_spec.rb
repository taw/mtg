# webmock/rspec

require_relative "spec_helper"
require "tmpdir"
require "pry"

describe "url2cod" do
  let(:binary) { Pathname(__dir__)+"../bin/url2cod" }

  describe "www.wizards.com" do
    it do
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          system "ruby", "-r#{__dir__}/mock_network", binary.to_s, "http://magic.wizards.com/en/articles/archive/top-decks/evolving-mana-bases-2016-04-15"
          binding.pry
        end
      end
    end
  end
end
