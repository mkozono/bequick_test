require "./sequencer.rb"
require 'fakefs/safe'

describe Sequencer do
  describe "process_four_letter_sequences" do
    before do
      FakeFS.activate!
      File.open("example_dictionary.txt", 'w') do |file|
        file.write("arrows\ncarrots\ngive\nme\n")
      end
      @sequencer = Sequencer.new("example_dictionary.txt", "sequences", "words")
      @sequencer.process_four_letter_sequences
    end
    after do
      FakeFS.deactivate!
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
end