require "pathname"
require_relative "../lib/magic_xml"

def Dir.chtmpdir
  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      yield(Pathname(dir))
    end
  end
end
