require_relative "magic_xml"
require "pathname"

class File
  def self.write(path, content)
    if path.is_a?(IO)
      path.write(content)
    else
      File.open(path, 'w') do |fh|
        fh.print content
      end
    end
  end
end

class Deck
  attr_accessor :name, :comment
  attr_reader :main, :side

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

  def to_txt
    out = ""
    out << "// NAME: #{@name}\n"
    out << "// COMMENTS: #{@comment.gsub(/\s+/, " ")}\n" unless @comment.nil? or @comment.empty?
    @main.each do |n,c|
      out << "#{c} #{n}\n"
    end
    out << "\n"
    out << "Sideboard\n"
    @side.each do |n,c|
      out << "#{c} #{n}\n"
    end
    out
  end

  def mage_cards_path
    Pathname(__dir__) + "../data/mage_cards.txt"
  end

  def mage_cards
    @mage_cards ||= Hash[mage_cards_path.readlines.map{|x| x.chomp.split("\t")}]
  end

  def mage_card_version(card)
    unless mage_cards[card]
      fixed_card = mage_cards.keys.find do |c|
        card.unicode_normalize(:nfd).downcase.scan(/[a-z]/).join ==
           c.unicode_normalize(:nfd).downcase.scan(/[a-z]/).join
      end
      if mage_cards[fixed_card]
        card = fixed_card
      end
    end
    return nil unless mage_cards[card]
    "[#{ mage_cards[card] }] #{card}"
  end

  def mage_compatible?
    (@main.keys + @side.keys).all?{|card| mage_card_version(card) }
  end

  def to_dck
    out = ""
    @main.each do |n,c|
      out << "#{c} #{mage_card_version(n)}\n"
    end
    @side.each do |n,c|
      out << "SB: #{c} #{mage_card_version(n)}\n"
    end
    out
  end

  def print!
    puts to_cod
  end

  def print_txt!
    puts to_txt
  end

  def save_as!(path)
    File.write(path, to_cod)
  end

  def save_as_txt!(path)
    File.write(path, to_txt)
  end

  def save_as_dck!(path)
    File.write(path, to_dck)
  end

  def find_free_filename(ext)
    suffix = ""
    cnt = 1
    while true
      file_name = "#{ @name.gsub("/", "") }#{ suffix }#{ ext }"
      return file_name unless File.exist?(file_name)
      cnt += 1
      suffix = " #{cnt}"
    end
  end

  def save!
    save_as! find_free_filename(".cod")
  end

  def save_txt!
    save_as_txt! find_free_filename(".txt")
  end

  def save_dck!
    save_as_dck! find_free_filename(".dck")
  end
end

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
