#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path('lib', File.dirname(__FILE__))

require 'language_guesser'
require 'optparse'

if $0 == __FILE__
  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{__FILE__} [--file GUESS_FILE] [SEED FILES...]"
    opts.separator ""
    opts.on('-f', '--file GUESS_FILE', 'File to guess') do |v|
      options[:filename] = v
    end
    opts.on('-h', '--help', 'Print this') do
      puts parser
      exit
    end
    opts.separator ""
    opts.separator "NB: Files in the seed/ directory will be used by default."
    opts.separator ""
    opts.separator "EXAMPLES"
    opts.separator ""
    opts.separator "To type and press enter to guess the language you typed:"
    opts.separator ""
    opts.separator "  ./guesslang.rb"
    opts.separator ""
    opts.separator "To guess the language of the file you specify:"
    opts.separator ""
    opts.separator "  ./guesslang.rb --file text.txt"
    opts.separator ""
    opts.separator "To specify different seed data:"
    opts.separator ""
    opts.separator "  ./guesslang.rb --file text.txt lang_a.1 lang_a.2 lang_b.1 lang_b.2"
  end

  parser.parse!
  seed_files = ARGV
  seed_files = Dir['seed/*'] if seed_files.empty?

  language_guesser = LanguageGuesser.new
  seed_files.each do |filename|
    language = File.basename(filename).gsub(/(\W|\d)/, '').downcase
    language_guesser.add_seed(language, File.read(filename))
  end
  language_guesser.prepare_seeds

  if options[:filename].nil?
    loop do
      puts language_guesser.guess_language($stdin.gets)
    end
  else
    puts language_guesser.guess_language(File.read(options[:filename]))
  end
end
