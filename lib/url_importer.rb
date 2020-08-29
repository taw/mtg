require "open-uri"
require "nokogiri"

class UrlImporter
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def host
    URI.parse(url).host
  end

  def doc
    @doc ||= Nokogiri::HTML(URI.open(url).read)
  end

  def parse_magicwizardscom
    doc.css(".deck-list-text").map do |node|
      deck = Deck.new
      node.css(".sorted-by-overview-container").css(".row").map(&:text).each do |line|
        line.strip!
        raise "Parse error: `#{line}'" unless line =~ /\A(\d+)\s+(.*)\z/
        deck.add_card_main! $2, $1.to_i
      end
      node.css(".sorted-by-sideboard-container").css(".row").map(&:text).each do |line|
        line.strip!
        raise "Parse error: `#{line}'" unless line =~ /\A(\d+)\s+(.*)\z/
        deck.add_card_side! $2, $1.to_i
      end
      deck.name = node.parent.parent.css("h4").text
      deck.comment = url
      deck
    end
  end

  def parse_wizardscom_displaythemedeck
    deck = Deck.new
    table = doc.css("b").find{|e| e.text == "#"}.parent.parent.parent
    table.css("tr")[1..-1].map{|tr| tr.css("td")[0,2].map(&:text)}.each do |count, name|
      deck.add_card_main! name, count.to_i
    end
    deck.name = doc.css("h2").text.strip
    deck.comment = url
    [deck]
  end

  def parse_wizardscom
    doc.css(".deck").map do |node|
      title = node.css('heading').text.strip
      link = URI.parse(@url) + node.css('.dekoptions a')[0][:href]
      parser = TextDeckParser.new
      parser.empty_line_starts_sideboard = true
      deck = parser.parse! URI.open(link)
      deck.name = title
      deck.comment = url
      deck
    end
  end

  def parse_scg
    deck = Deck.new
    doc.css(".deck_card_wrapper li").each do |cards|
      in_sideboard = !cards.ancestors(".deck_sideboard").empty?
      raise "Parse error: `#{cards}'" unless cards.text =~ /\A(\d+)\s+(.*)/
      if in_sideboard
        deck.add_card_side! $2, $1.to_i
      else
        deck.add_card_main! $2, $1.to_i
      end
    end
    title = doc.css(".deck_title").text
    deck.name = title
    deck.comment = @url
    [deck]
  end

  def parse_mtgtop8
    title = doc.title.sub(" @ mtgtop8.com", "")
    deck = Deck.new
    zone = :main
    # G14 - cards
    # O13 - headers, two are special, rest are like "37 LANDS"
    doc.css(".G14,.O13").sort.each do |node|
      text = node.text
      if node['class'] == 'G14'
        raise "Parse error: `#{text}'" unless text =~ /\A(\d+)\s+(.*)/
        deck.send("add_card_#{zone}!", $2, $1.to_i)
      elsif text == "SIDEBOARD"
        zone = :side
      elsif text == "COMMANDER"
        zone = :cmd
      else
        zone = :main
      end
    end
    deck.name = title
    deck.comment = @url
    [deck]
  end

  def parse_mtggoldfish
    deck = Deck.new
    title = doc.css("h1.deck-view-title")[0]
      .text.strip
      .gsub(/[[:space:]]+/, " ")
      .sub(/\s+Suggest a Better Name/, "")
    in_sideboard = false
    doc.css("#tab-online .deck-view-deck-table tr").each do |row|
      header = row.css(".deck-header").text.strip
      if header.empty?
        count = row.css(".deck-col-qty").text.strip.to_i
        # Some card names are not links, warn
        name  = row.css("td a").text.strip
        name2 = row.css("td:nth-child(2)").text.strip
        if name != name2
          warn "Names don't match: `#{name}' `#{name2}'"
          name = name2
        end
        if in_sideboard
          deck.add_card_side! name, count
        else
          deck.add_card_main! name, count
        end
      elsif header =~ /\ASideboard\s*\(\d+\)\z/
        in_sideboard = true
      end
    end
    deck.name = title
    deck.comment = @url
    [deck]
  end

  def parse_gamepedia
    doc.css(".ext-scryfall-deck").map do |node|
      deck = Deck.new
      title = node.css(".ext-scryfall-decktitle").text.strip
      node.css(".ext-scryfall-decksection").each do |section|
        header = section.css("h4").text.strip
        in_sideboard = header =~ /\ASideboard\s*\(\d+\)\z/
        section.css("p").each do |row|
          count = row.css(".ext-scryfall-deckcardcount").text.strip.to_i
          name = row.css("a.ext-scryfall-link,a.ext-scryfall-cardname").text.strip
          if in_sideboard
            deck.add_card_side! name, count
          else
            deck.add_card_main! name, count
          end
        end
      end
      deck.name = title
      deck.comment = @url
      deck
    end
  end

  def parse
    case host
    when "www.wizards.com"
      if url =~ /displaythemedeck.asp/
        parse_wizardscom_displaythemedeck
      else
        parse_wizardscom # Old website
      end
    when "magic.wizards.com"
      parse_magicwizardscom # New website
    when "sales.starcitygames.com", "old.starcitygames.com"
      parse_scg
    when "www.mtgtop8.com", "mtgtop8.com"
      parse_mtgtop8
    when "www.mtggoldfish.com"
      parse_mtggoldfish
    when "mtg.gamepedia.com"
      parse_gamepedia
    else
      raise "Don't know how to import from #{host}"
    end
  end
end
