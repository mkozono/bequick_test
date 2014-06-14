require "./sequencer.rb"
require 'fakefs/safe'

describe Sequencer do

  before do
    FakeFS.activate!
    File.open("example_dictionary.txt", 'w') do |file|
      file.write("arrows\ncarrots\ngive\nme\nz's\n")
    end
    @sequencer = Sequencer.new("example_dictionary.txt", "sequences", "words")
  end
  after do
    FakeFS.deactivate!
  end

  describe "#process_four_letter_sequences" do
    before do
      @sequencer.process_four_letter_sequences
    end
    it "creates the sequences file" do
      expect(File.exists?('sequences')).to eq true
    end
    it "creates the words file" do
      expect(File.exists?('words')).to eq true
    end
    context "sequences file" do
      it "contains the unique four letter sequences" do
        content = File.read("sequences")
        expect(content).to eq "carr\ngive\nrots\nrows\nrrot\nrrow\n"
      end
    end
    context "words file" do
      it "contains the words corresponding to the sequences" do
        content = File.read("words")
        expect(content).to eq "carrots\ngive\ncarrots\narrows\ncarrots\narrows\n"
      end
    end
  end

  describe "#get_sequences" do
    subject { @sequencer.get_sequences("example_dictionary.txt", 4) }
    it "returns sequences as the first element" do
      expect(subject[0]).to match_array ["carr", "give", "rots", "rows", "rrot", "rrow"]
    end
    it "returns words as the second element" do
      expect(subject[1]).to match_array ["carrots", "give", "carrots", "arrows", "carrots", "arrows"]
    end
  end

  describe "#parse_dictionary_file" do
    subject { @sequencer.parse_dictionary_file("example_dictionary.txt", 4) }
    it "returns a hash whose keys are sequences and values are words" do
      expected_hash = {
        "carr" => "carrots",
        "give" => "give",
        "rots" => "carrots",
        "rows" => "arrows",
        "rrot" => "carrots",
        "rrow" => "arrows"
      }
      expect(subject).to eq expected_hash
    end
  end

  describe "#parse_line" do
    subject { @sequencer.parse_line(line, 4) }
    context "when the line is at least as long as sequence_length" do
      let(:line) { "coffee" }
      it { should eq ["coff", "offe", "ffee"] }
    end
    context "when the line is 3 characters long or less" do
      let(:line) { "dog" }
      it { should be_empty }
    end
  end

  describe "#output_sequences" do
  end
end