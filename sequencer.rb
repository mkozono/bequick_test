class Sequencer

  def initialize(dictionary_filename, sequence_filename, words_filename)
    @dictionary_filename = dictionary_filename
    @sequence_filename = sequence_filename
    @words_filename = words_filename
  end

  def process_four_letter_sequences
    sequence_hash = parse_dictionary_file(@dictionary_filename, 4)
    sequences, words = get_sequences_and_words(sequence_hash)
    write_array_to_file(sequences, @sequence_filename)
    write_array_to_file(words, @words_filename)
  end

  def parse_dictionary_file(dictionary_filename, sequence_length)
    sequence_hash = {}
    dupes = []
    File.open(dictionary_filename) do |file|
      file.each_line do |line|
        line = line.chomp
        sequences = parse_line(line, sequence_length)
        sequences.each do |sequence|
          dupes << sequence if sequence_hash.has_key?(sequence)
          sequence_hash[sequence] = line
        end
      end
    end
    dupes.each { |dupe| sequence_hash.delete(dupe) }
    sequence_hash
  end

  def parse_line(line, sequence_length)
    num_sequences = line.length - sequence_length
    (0..num_sequences).map do |index|
      line[index, sequence_length]
    end
  end

  def get_sequences_and_words(sequence_hash)
    sequences = sequence_hash.keys.sort
    words = sequences.map do |sequence|
      sequence_hash[sequence]
    end
    [sequences, words]
  end

  def write_array_to_file(array_object, filename)
    File.open(filename, 'w') do |file|
      file.puts(array_object)
    end
  end


end