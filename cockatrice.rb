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

class TextDeckParser
  attr_accessor :empty_line_starts_sideboard, :verbose
  attr_reader :deck
  def initialize
    @deck = Deck.new
    @in_sideboard = false
    @verbose = false
    @empty_line_starts_sideboard = false
  end

  def debug!(msg)
    STDERR.puts(msg) if @verbose
  end

  def process_comment!(comment)
    case comment
    when /\ANAME\s*:\s*(.*)/
      deck.name = $1
    else
      debug! "Unrecognized comment: #{comment}"
    end
  end

  def parse_line!(line)
    line = line.strip
    case line
    when /\ASB:\s*(\d+)\s*(.*)\z/
      deck.add_card! $2, $1.to_i, true
    when /\A(\d+)\s*(.*)\z/
      deck.add_card! $2, $1.to_i, @in_sideboard
    when /\ASideboard:?/i
      @in_sideboard = true
    when ""
      @in_sideboard = true if empty_line_starts_sideboard
    when /\A\/\/(.*)/
      process_comment! $1.strip
    else
      debug! "Unrecognized line: #{line}"
    end
  end

  def parse!(input)
    input.each do |line|
      parse_line! line.chomp
    end
    deck
  end
end
