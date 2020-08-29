class CockatriceDeckParser
  attr_reader :deck
  def initialize
    @deck = Deck.new
  end

  def parse!(input)
    cod = XML.parse(input)
    @deck.name = cod[:@deckname]
    @deck.comment = cod[:@comments]
    cod.children(:zone).each do |zone|
      zone.children(:card).each do |card|
        @deck.add_card!(card[:name], card[:number].to_i, zone[:name] == "side")
      end
    end
  end
end
