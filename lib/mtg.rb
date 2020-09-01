require_relative "magic_xml"
require_relative "deck"
require_relative "text_deck_parser"
require_relative "cockatrice_deck_parser"
require "pathname"

class File
  def self.write(path, content)
    if path.is_a?(IO)
      path.write(content)
    else
      File.open(path, "w") do |fh|
        fh.print content
      end
    end
  end
end
