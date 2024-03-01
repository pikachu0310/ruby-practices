# frozen_string_literal: true

require 'optparse'
require_relative 'directory_scanner'
require_relative 'file_info'

class LsCommand
  def initialize
    @options = {}
  end

  def parse_options
    OptionParser.new do |opts|
      opts.on('-a', '--all') { |v| @options[:a] = v }
      opts.on('-r', '--reverse') { |v| @options[:r] = v }
      opts.on('-l') { |v| @options[:l] = v }
    end.parse!
  end

  def run
    parse_options
    scanner = DirectoryScanner.new(@options)
    files = scanner.scan
    if @options[:l]
      files.each { |file| puts file.details }
    else
      puts files.map(&:path)
    end
  end
end
