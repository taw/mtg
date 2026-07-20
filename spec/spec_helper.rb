require "pathname"
require "nokogiri"
require "tmpdir"
require "pry"

def Dir.chtmpdir
  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      yield(Pathname(dir))
    end
  end
end
