require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Process the dictionary for four letter sequences."
task :process_four_letter_sequences do
  require './sequencer'
  sequencer = Sequencer.new("dictionary.txt", "sequences", "words")
  sequencer.process_four_letter_sequences
end