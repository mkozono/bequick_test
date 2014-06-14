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

  describe "#parse_dictionary_file" do
    subject { @sequencer.parse_dictionary_file("example_dictionary.txt", 4) }
    it "returns an array of SequenceWithWord objects" do
      expected_array = [
        Sequencer::SequenceWithWord.new("arro", "arrows"),
        Sequencer::SequenceWithWord.new("arro", "carrots"),
        Sequencer::SequenceWithWord.new("carr", "carrots"),
        Sequencer::SequenceWithWord.new("give", "give"),
        Sequencer::SequenceWithWord.new("rots", "carrots"),
        Sequencer::SequenceWithWord.new("rows", "arrows"),
        Sequencer::SequenceWithWord.new("rrot", "carrots"),
        Sequencer::SequenceWithWord.new("rrow", "arrows")
      ]
      expect(subject).to match_array expected_array
    end
  end

  describe "#parse_line" do
    subject { @sequencer.parse_line(line, 4) }
    context "when the line is at least as long as sequence_length" do
      let(:line) { "coffee" }
      it "returns an array of SequenceWithWord objects" do
        expect(subject).to eq [
          Sequencer::SequenceWithWord.new("coff","coffee"), 
          Sequencer::SequenceWithWord.new("offe","coffee"), 
          Sequencer::SequenceWithWord.new("ffee","coffee")
        ]
      end
    end
    context "when the line is 3 characters long or less" do
      let(:line) { "dog" }
      it { should be_empty }
    end
  end

  describe "#remove_sequences_with_multiple_occurrences" do
    subject { @sequencer.remove_sequences_with_multiple_occurrences(sequences_with_words) }
    let(:sequences_with_words) {
      [
        Sequencer::SequenceWithWord.new("coff", "coffee"),
        Sequencer::SequenceWithWord.new("offe", "coffee"),
        Sequencer::SequenceWithWord.new("ffee", "coffee"),
        Sequencer::SequenceWithWord.new("coff", "coffer"),
        Sequencer::SequenceWithWord.new("offe", "coffer"),
        Sequencer::SequenceWithWord.new("ffer", "coffer")
      ]
    }
    it "returns the array without sequences that occurred more than once" do
      expect(subject).to eq [Sequencer::SequenceWithWord.new("ffee", "coffee"), Sequencer::SequenceWithWord.new("ffer", "coffer")]
    end
  end

  describe "#write_array_to_file" do
    it "writes each element as a line in the file" do
      @sequencer.write_array_to_file(["abc", "123"], "filename")
      expect(File.read("filename")).to eq "abc\n123\n"
    end
  end
end