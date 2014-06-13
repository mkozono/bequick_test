class Sequencer

  def initialize(dictionary_filename, sequence_filename, words_filename)
    @dictionary_filename = dictionary_filename
    @sequence_filename = sequence_filename
    @words_filename = words_filename
  end

  def process_four_letter_sequences
    File.open(@sequence_filename, 'w') do |file|
      file.write('hello')
    end
    File.open(@words_filename, 'w') do |file|
      file.write('hello')
    end
  end
end