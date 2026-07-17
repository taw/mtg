require_relative "spec_helper"

describe "XML" do
  describe "#descendants with multiple patterns" do
    let(:doc) { XML.parse("<r><a><b><c>1</c></b></a><a><c>2</c></a></r>") }

    it "matches descendants at any depth, not just direct children" do
      # <c>1</c> is nested under <a><b>, <c>2</c> is a direct child of <a>.
      # Both must be found.
      expect(doc.descendants(:a, :c).map(&:text).sort).to eq(["1", "2"])
    end
  end

  describe "#children with multiple patterns" do
    let(:doc) { XML.parse("<r><a><b><c>1</c></b></a><a><c>2</c></a></r>") }

    it "only matches direct children of the matched parent" do
      expect(doc.children(:a, :c).map(&:text)).to eq(["2"])
    end
  end
end
