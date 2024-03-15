# frozen_string_literal: true

require 'optparse'
require_relative 'directory_scanner'
require_relative 'file_info'

class LsCommand
  def initialize
    @options = {}
    parse_options
    @files = DirectoryScanner.new(@options).scan(@directory)
  end

  def parse_options
    OptionParser.new do |opts|
      opts.on('-a', '--all') { |v| @options[:a] = v }
      opts.on('-r', '--reverse') { |v| @options[:r] = v }
      opts.on('-l') { |v| @options[:l] = v }
    end.parse!
  end

  def run
    if @options[:l]
      print_detailed_files(@files)
    else
      print_files_in_columns(@files.map { |file| File.basename(file.path) })
    end
  end

  private

  def print_files_in_columns(paths)
    columns = 3
    rows = (paths.length / columns.to_f).ceil
    paths = paths.each_slice(rows).to_a
    paths.last.fill(nil, paths.last.length...rows) if paths.last.length < rows

    # 各列の最大幅を計算
    column_widths = paths.map do |column|
      column.compact.max_by(&:length).length + 2 # 最長ファイル名 + スペース2
    end

    paths.transpose.each do |row|
      row.each_with_index do |file, index|
        file ||= '' # nilの場合は空文字列に置き換え
        printf "%-#{column_widths[index]}s", file
      end
      puts
    end
  end

  def print_detailed_files(files)
    widths = {
      mode: 10, # "-rwxr-xr-x"
      nlink: files.map { |f| f.stat.nlink.to_s.length }.max,
      owner: files.map { |f| Etc.getpwuid(f.stat.uid).name.size }.max,
      group: files.map { |f| Etc.getgrgid(f.stat.gid).name.size }.max,
      size: files.map { |f| f.stat.size.to_s.size }.max,
      mtime: 12, # "Dec 20 12:45"
      filename: files.map { |f| File.basename(f.path).size }.max
    }
    files.each do |file|
      puts file.details(widths)
    end
  end
end
