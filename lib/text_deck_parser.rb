class TextDeckParser
  # MTG Arena decklists annotate every card with set code and collector
  # number, like `4 Bonecrusher Giant (ELD) 115`
  # Moxfield, Archidekt, TappedOut, ManaBox, MTGGoldfish, and Cockatrice
  # all read and write variations of it, so accept the whole family:
  # count can be `4` or `4x`, collector number is optional (some exporters
  # skip it) and not always a plain number (`(PLST) MH2-123`)
  ARENA_CARD = /\A(\d+)x?\s+(.+?)\s+\(([A-Za-z0-9_]{2,7})\)(?:\s+(\S+))?\z/

  ARENA_SECTIONS = {
    "about" => :about,
    "deck" => :main,
    "decklist" => :main,
    "maindeck" => :main,
    "mainboard" => :main,
    "commander" => :cmd,
    "companion" => :companion,
    "maybeboard" => :maybeboard,
    "sideboard" => :side,
  }
  ARENA_SECTION = /\A(#{ARENA_SECTIONS.keys.join("|")}):?\z/i

  # Archidekt colour labels: `^Label,#colour^`
  ARENA_LABEL = /\s*\^[^\^]*\^/
  # Archidekt user-defined categories, which is also how it expresses
  # sections: `[Maybeboard{noDeck}{noPrice},Mana Advantage]`
  ARENA_CATEGORIES = /\s*\[([^\[\]]+)\]\s*\z/
  ARENA_CATEGORY_ZONES = {
    "commander" => :cmd,
    "maybeboard" => :maybeboard,
    "sideboard" => :side,
  }
  # Moxfield `#tag` and `#!collection-tag`, Deckstats `# per card comment`
  ARENA_COMMENT = /\s+#.*\z/
  # `*F*` foil and `*E*` etched foil (Moxfield, Archidekt, TappedOut, Forge),
  # `*CMDR*` commander (TappedOut), `(F)` foil (MTGGoldfish)
  # This deck model has nowhere to put finish, so it's just dropped
  ARENA_MARKERS = /\s*(?:\*[A-Za-z]+\*|\(F\))/

  attr_accessor :empty_line_starts_sideboard, :verbose
  attr_writer :arena
  attr_reader :deck

  def initialize
    @deck = Deck.new
    @zone = :main
    @verbose = false
    @empty_line_starts_sideboard = false
    # nil means autodetect
    @arena = nil
  end

  def arena?
    @arena
  end

  def debug!(msg)
    warn(msg) if @verbose
  end

  # Deckstats marks its sections with comments
  COMMENT_SECTIONS = {
    "main" => :main,
    "mainboard" => :main,
    "deck" => :main,
    "commander" => :cmd,
    "maybeboard" => :maybeboard,
    "side" => :side,
    "sideboard" => :side,
  }
  COMMENT_SECTION = /\A(#{COMMENT_SECTIONS.keys.join("|")})\z/i

  def process_comment!(comment)
    case comment
    when /\ANAME\s*:\s*(.*)/
      deck.name = $1
    when COMMENT_SECTION
      @zone = COMMENT_SECTIONS[$1.downcase]
    else
      debug! "Unrecognized comment: #{comment}"
    end
  end

  def add_card!(name, number, zone = @zone)
    case zone
    when :about
      debug! "Card in About section: #{number} #{name}"
    when :companion
      # Arena repeats the companion in the sideboard,
      # so adding it here would double count it
      debug! "Skipping companion: #{number} #{name}"
    when :maybeboard
      debug! "Skipping maybeboard card: #{number} #{name}"
    else
      deck.send("add_card_#{zone}!", name, number)
    end
  end

  def arena_zone_from_categories(categories)
    categories.split(",").each do |category|
      # Archidekt appends `{noDeck}` style flags to its category names
      zone = ARENA_CATEGORY_ZONES[category.sub(/\{.*/, "").strip.downcase]
      return zone if zone
    end
    nil
  end

  # `4 Ashnod's Altar (EMA) 218 *F* [Ramp]` => ["Ashnod's Altar", 4, nil]
  # Third element is a zone the annotations ask for, if any
  def parse_arena_card(line)
    zone = nil
    line = line.gsub(ARENA_LABEL, "")
    line = line.sub(ARENA_CATEGORIES) { zone = arena_zone_from_categories($1); "" }
    line = line.sub(ARENA_COMMENT, "")
    line = line.gsub(ARENA_MARKERS) { zone = :cmd if $&.upcase.include?("CMDR"); "" }
    return nil unless line.strip =~ ARENA_CARD
    [$2, $1.to_i, zone]
  end

  def parse_arena_line!(line)
    if @zone == :about and line =~ /\AName\s+(.*)\z/i
      deck.name = $1.strip
      return true
    end
    if line =~ ARENA_SECTION
      @zone = ARENA_SECTIONS[$1.downcase]
      return true
    end
    name, number, zone = parse_arena_card(line)
    return false unless name
    add_card! name, number, zone || @zone
    true
  end

  def parse_line!(line)
    line = line.strip
    return if arena? and parse_arena_line!(line)
    case line
    when /\ASB:\s*(\d+)x?\s*(.*)\z/
      deck.add_card_side! $2, $1.to_i
    when /\ACOMMANDER:\s*(\d+)x?\s*(.*)\z/i
      deck.add_card_cmd! $2, $1.to_i
    when /\A(\d+)x?\s*(.*)\z/
      add_card! $2, $1.to_i
    when /\ASideboard:?/i, /\A\[Sideboard\]/i
      @zone = :side
    when /\A\[Commander\]/i
      @zone = :cmd
    when /\A\[Main\]/i
      @zone = :main
    when ""
      # Arena uses empty lines to separate its named sections
      @zone = :side if empty_line_starts_sideboard and not arena?
    when /\AName\s*[=:]\s*(.*)/i
      # `Name=` is Forge, `NAME:` is XMage
      deck.name = $1.strip
    when /\A\/\/(.*)/
      process_comment! $1.strip
    else
      debug! "Unrecognized line: #{line}"
    end
  end

  # Set codes and collector numbers are unique enough to Arena
  # that a single such line is enough to tell the format apart
  def arena_format?(lines)
    lines.any? { |line| parse_arena_card(line.strip) }
  end

  def parse!(input)
    lines = input.map(&:chomp)
    @arena = arena_format?(lines) if @arena.nil?
    lines.each do |line|
      parse_line! line
    end
    deck
  end
end
