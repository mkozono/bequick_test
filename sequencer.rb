class Sequencer

  SequenceWithWord = Struct.new :sequence, :word

  def initialize(dictionary_filename, sequence_filename, words_filename)
    @dictionary_filename = dictionary_filename
    @sequence_filename = sequence_filename
    @words_filename = words_filename
  end

  def process_four_letter_sequences
    sequences_with_words = parse_dictionary_file(@dictionary_filename, 4)
    sequences_with_words = remove_sequences_with_multiple_occurrences(sequences_with_words)
    sequences_with_words.sort_by!(&:sequence)
    sequences = sequences_with_words.map(&:sequence)
    words = sequences_with_words.map(&:word)
    write_array_to_file(sequences, @sequence_filename)
    write_array_to_file(words, @words_filename)
  end

  def parse_dictionary_file(dictionary_filename, sequence_length)
    sequences_with_words = []
    File.open(dictionary_filename) do |file|
      file.each_line do |line|
        line = line.chomp
        sequences_with_words += parse_line(line, sequence_length)
      end
    end
    sequences_with_words
  end

  def parse_line(line, sequence_length)
    num_sequences = line.length - sequence_length
    (0..num_sequences).map do |index|
      SequenceWithWord.new line[index, sequence_length], line
    end
  end

  def remove_sequences_with_multiple_occurrences(sequences_with_words)
    occurrences = sequences_with_words.each_with_object(Hash.new 0) do |sequence_with_word, counts|
      counts[sequence_with_word.sequence] += 1
    end
    sequences_with_words.delete_if do |sequence_with_word|
      occurrences[sequence_with_word.sequence] > 1
    end
  end

  def write_array_to_file(array_object, filename)
    File.open(filename, 'w') do |file|
      file.puts(array_object)
    end
  end

end