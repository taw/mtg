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
        if zone[:name] == "side"
          @deck.add_card_side! card[:name], card[:number].to_i
        else
          @deck.add_card_main! card[:name], card[:number].to_i
        end
      end
    end
  end
end
