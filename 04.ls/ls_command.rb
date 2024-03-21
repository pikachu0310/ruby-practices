# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'directory_scanner'
require_relative 'file_info'

class LsCommand
  def initialize
    @options = parse_options
    @directory = ARGV.empty? ? '.' : ARGV[0]
    @files = DirectoryScanner.new(@options).scan(@directory)
  end

  def run
    if @options[:l]
      print_detailed_files
    else
      print_files_in_columns
    end
  end

  private

  def parse_options
    options = {}
    OptionParser.new do |opts|
      opts.on('-a', '--all') { options[:a] = true }
      opts.on('-r', '--reverse') { options[:r] = true }
      opts.on('-l') { options[:l] = true }
      opts.banner = 'Usage: ls.rb [options] [directory]'
    end.parse!
    options
  end

  def print_detailed_files
    widths = calculate_widths(@files)
    @files.each do |file|
      puts file.details(widths)
    end
  end

  def calculate_widths(files)
    {
      mode: 10, # "-rwxr-xr-x".length
      nlink: files.map { |f| f.nlink_str.length }.max,
      owner: files.map { |f| f.owner_name.length }.max,
      group: files.map { |f| f.group_name.length }.max,
      size: files.map { |f| f.size_str.length }.max,
      mtime: 12, # "Mar 10 12:34".length
      filename: files.map { |f| File.basename(f.path).length }.max
    }
  end

  def print_files_in_columns
    filenames = @files.map(&:filename)
    columns = calculate_columns(filenames)
    print_columns(columns)
  end

  def calculate_columns(paths, columns = 3)
    rows = (paths.length.to_f / columns).ceil
    paths.each_slice(rows).to_a
  end

  def print_columns(columns)
    max_size = columns.map(&:size).max
    columns.each { |column| column.fill(nil, column.size...max_size) }

    column_widths = columns.map do |column|
      column.compact.max_by(&:length).length + 2
    end

    columns.transpose.each do |row|
      row.each_with_index do |file, index|
        printf "%-#{column_widths[index]}s", (file || '')
      end
      puts
    end
  end
end
