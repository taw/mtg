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
      deck.add_card_main! $2, $1.to_i
    when /\A(\d+)\s*(.*)\z/
      if @in_sideboard
        deck.add_card_side! $2, $1.to_i
      else
        deck.add_card_main! $2, $1.to_i
      end
    when /\ASideboard:?/i, /\A\[Sideboard\]/i
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
