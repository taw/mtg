class TextDeckParser
  # MTG Arena decklists annotate every card with set code and collector
  # number, like `4 Bonecrusher Giant (ELD) 115`
  # Collector number is optional, some exporters skip it
  ARENA_CARD = /\A(\d+)\s+(.+?)\s+\(([A-Za-z0-9_]+)\)(?:\s+([A-Za-z0-9]+))?\z/
  ARENA_SECTIONS = {
    "about" => :about,
    "deck" => :main,
    "commander" => :cmd,
    "companion" => :companion,
    "sideboard" => :side,
  }
  ARENA_SECTION = /\A(#{ARENA_SECTIONS.keys.join("|")})\z/i

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

  def process_comment!(comment)
    case comment
    when /\ANAME\s*:\s*(.*)/
      deck.name = $1
    else
      debug! "Unrecognized comment: #{comment}"
    end
  end

  def add_card!(name, number)
    case @zone
    when :about
      debug! "Card in About section: #{number} #{name}"
    when :companion
      # Arena repeats the companion in the sideboard,
      # so adding it here would double count it
    else
      deck.send("add_card_#{@zone}!", name, number)
    end
  end

  def parse_arena_line!(line)
    if @zone == :about and line =~ /\AName\s+(.*)\z/i
      deck.name = $1.strip
      return true
    end
    case line
    when ARENA_SECTION
      @zone = ARENA_SECTIONS[$1.downcase]
      true
    when ARENA_CARD
      add_card! $2, $1.to_i
      true
    else
      false
    end
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
    when /\AName\s*=\s*(.*)/i
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
    lines.any? { |line| line.strip =~ ARENA_CARD }
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
