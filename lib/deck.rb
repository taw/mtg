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
    @side.each { |c, n| result[c] += n }
    @cmd.each { |c, n| result[c] += n }
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
    name.tr!("’", "'")
    name.gsub!("Æ", "Ae")
    name.gsub!(/\AAether/, "Aether")
    # Split/Fuse cards
    name.gsub!(%r{\s*(/+|&)\s*}, " // ")
    # Strip expansion name if any
    name.sub!(/\A\[[A-Z0-9]+\]\s+/, "")
    # Strip expansion name + number if any
    name.sub!(/\A\[[A-Z0-9]+:\S+\]\s+/, "")
    # Strip Forge annotations
    parts = name.split("|")
    if parts.size > 1
      name = parts[0]
      # 2nd is expansion code
      # 3rd is some internal Forge id that means nothing to anyone else
    end
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
    out << "// SOURCE: #{@comment.gsub(/\s+/, " ")}\n" unless @comment.nil? || @comment.empty?
    @cmd.each do |n, c|
      out << "COMMANDER: #{c} #{n}\n"
    end
    @main.each do |n, c|
      out << "#{c} #{n}\n"
    end
    out << "\n"
    out << "Sideboard\n"
    @side.each do |n, c|
      out << "#{c} #{n}\n"
    end
    out
  end

  def xmage_cards_path
    Pathname(__dir__) + "../data/xmage_cards.txt"
  end

  # This really needs best version picker, it's quite otherwise
  # Post-processing with pimp up is not really best idea
  def xmage_cards
    @xmage_cards ||= begin
      xmage_cards_path
        .readlines
        .map{|row| row.chomp.split("\t") }
        .group_by{|r| r[1] }
        .map{|name, versions|
          [name, versions.map{|s,_,n| [s.upcase, n]}.last.join(":")]
        }.to_h
    end
    @xmage_cards
  end

  def mage_card_version(card)
    unless xmage_cards[card]
      fixed_card = xmage_cards.keys.find { |c|
        card.unicode_normalize(:nfd).downcase.scan(/[a-z]/).join ==
          c.unicode_normalize(:nfd).downcase.scan(/[a-z]/).join
      }
      card_part = card.split("//")[0].strip
      fixed_card ||= xmage_cards.keys.find { |c|
        card_part.unicode_normalize(:nfd).downcase.scan(/[a-z]/).join ==
          c.unicode_normalize(:nfd).downcase.scan(/[a-z]/).join
      }
      if xmage_cards[fixed_card]
        card = fixed_card
      end
    end
    if xmage_cards[card]
      "[#{xmage_cards[card]}] #{card}"
    else
      warn "Cannot find Mage card #{card}"
      nil
    end
  end

  def mage_compatible?
    (@main.keys + @side.keys).all? { |card| mage_card_version(card) }
  end

  def to_dck
    out = ""
    cmd.each do |n, c|
      # Not official
      out << "#{c} #{mage_card_version(n)}"
    end
    main.each do |n, c|
      out << "#{c} #{mage_card_version(n)}\n"
    end
    side.each do |n, c|
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
    loop do
      file_name = "#{@name.delete("/")}#{suffix}#{ext}"
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
