describe "pimp_up_xmage_decklist" do
  let(:binary) { Pathname(__dir__) + "../bin/pimp_up_xmage_decklist" }

  describe "--list" do
    it "runs and lists known pimp-up versions" do
      output = `#{binary} --list`
      expect($?.success?).to be true
      expect(output).to include("1 [MPS:6] Aether Vial")
    end
  end

  describe "pimping a decklist in place" do
    it "upgrades cards to their nicer version and backs up the original" do
      Dir.chtmpdir do |dir|
        deck = dir + "deck.dck"
        original = "4 [FUT:48] Arcanum Wings\n2 [ZZZ:1] Aether Vial\nLAYOUT foo\n"
        deck.write(original)

        system("#{binary} #{deck}")

        expect(deck.read).to eq("4 [FUT:48] Arcanum Wings\n2 [MPS:6] Aether Vial\n")
        expect((dir + "deck.dck.bak").read).to eq(original)
      end
    end
  end
end
