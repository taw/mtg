class TextDeckParser
  attr_accessor :empty_line_starts_sideboard, :verbose
  attr_reader :deck

  def initialize
    @deck = Deck.new
    @zone = :main
    @verbose = false
    @empty_line_starts_sideboard = false
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

  def parse_line!(line)
    line = line.strip
    case line
    when /\ASB:\s*(\d+)\s*(.*)\z/
      deck.add_card_main! $2, $1.to_i
    when /\A(\d+)\s*(.*)\z/
      deck.send("add_card_#{@zone}!", $2, $1.to_i)
    when /\ASideboard:?/i, /\A\[Sideboard\]/i
      @zone = :side
    when /\A\[Commander\]/i
      @zone = :cmd
    when /\A\[Main\]/i
      @zone = :main
    when ""
      @zone = :side if empty_line_starts_sideboard
    when /\AName\s*=\s*(.*)/i
      deck.name = $1.strip
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
