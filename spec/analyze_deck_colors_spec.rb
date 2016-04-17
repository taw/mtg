require_relative "spec_helper"

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
    let(:expected) { "???" }
    it do
      expect(colors).to eq("wur")
    end
  end
end
