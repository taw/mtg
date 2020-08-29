class Deck
  attr_accessor :name, :comment
  attr_reader :main, :side, :cmd

  def initialize
    @main = Hash.new(0)
    @side = Hash.new(0)
    @cmd = Hash.new(0)
    @name = ""
    @comment = ""
  end

  def each_main_card(&blk)
    @main.to_a.sort.each(&blk)
  end

  def each_side_card(&blk)
    @side.to_a.sort.each(&blk)
  end

  def side_and_cmd
    result = Hash.new(0)
    @side.each{|c,n| result[c] += n}
    @cmd.each{|c,n| result[c] += n}
    result
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
    # Strip expansion name + number if any
    name.sub!(/\A\[[A-Z0-9]+:\S+\]\s+/, "")
    name
  end

  def add_card_main!(name, number)
    @main[canonical_name(name)] += number
  end

  def add_card_side!(name, number)
    @side[canonical_name(name)] += number
  end

  def add_card_cmd!(name, number)
    @cmd[canonical_name(name)] += number
  end

  def to_cod
    out = xml(:cockatrice_deck)
    out << (deckname = xml(:deckname))
    out << (comments = xml(:comments))
    out << zone_to_xml(main, :main)
    out << zone_to_xml(side_and_cmd, :side)
    out.add_pretty_printing!
    # Don't prettyprint within these
    deckname << @name
    comments << @comment
    out.to_s + "\n"
  end

  def to_txt
    out = ""
    out << "// NAME: #{@name}\n"
    out << "// COMMENTS: #{@comment.gsub(/\s+/, " ")}\n" unless @comment.nil? or @comment.empty?
    @cmd.each do |n,c|
      out << "COMMANDER: #{c} #{n}\n"
    end
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
    cmd.each do |n,c|
      # Not official
      out << "#{c} #{mage_card_version(n)}"
    end
    main.each do |n,c|
      out << "#{c} #{mage_card_version(n)}\n"
    end
    side.each do |n,c|
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
