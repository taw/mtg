require "magic_xml"

class Deck
  attr_accessor :name, :comment

  def initialize
    @main = Hash.new(0)
    @side = Hash.new(0)
    @name = ""
    @comment = ""
  end

  def each_main_card(&blk)
    @main.to_a.sort.each(&blk)
  end

  def each_side_card(&blk)
    @side.to_a.sort.each(&blk)
  end

  def zone_to_xml(zone, name)
    xml(:zone, name: name) do
      zone.to_a.sort.each do |name, count|
        card! number: count, price: 0, name: name
      end
    end
  end

  def canonical_name(name)
    # Common differences between cards.xml
    # and what people type in their decklists online
    name = name.dup
    # Unicode
    name.gsub!("’", "'")
    name.gsub!("Æ", "AE")
    name.gsub!(/\AAether/, "AEther")
    # Split/Fuse cards
    name.gsub!(%r[\s*(/+|&)\s*], " // ")
    # Strip expansion name if any
    name.sub!(/\A\[[A-Z0-9]+\]\s+/, "")
    name
  end

  def add_card!(name, number, sideboard)
    name = canonical_name(name)
    if sideboard
      @side[name] += number
    else
      @main[name] += number
    end
  end

  def to_cod
    out = xml(:cockatrice_deck)
    out << (deckname = xml(:deckname))
    out << (comments = xml(:comments))
    out << zone_to_xml(@main, :main)
    out << zone_to_xml(@side, :side)
    out.add_pretty_printing!
    # Don't prettyprint within these
    deckname << @name
    comments << @comment
    out
  end

  def print!
    puts to_cod
  end

  def save_as!(path)
    File.open(path, 'w') do |fh|
      fh.puts to_cod
    end
  end
end
