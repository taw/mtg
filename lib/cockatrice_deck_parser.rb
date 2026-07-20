class CockatriceDeckParser
  attr_reader :deck
  def initialize
    @deck = Deck.new
  end

  def parse!(input)
    cod = Nokogiri::XML(input).root
    @deck.name = cod.at_xpath("deckname")&.text || ""
    @deck.comment = cod.at_xpath("comments")&.text || ""
    cod.xpath("zone").each do |zone|
      zone.xpath("card").each do |card|
        if zone["name"] == "side"
          @deck.add_card_side! card["name"], card["number"].to_i
        else
          @deck.add_card_main! card["name"], card["number"].to_i
        end
      end
    end
  end
end
