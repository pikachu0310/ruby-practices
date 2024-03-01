# frozen_string_literal: true

class DirectoryScanner
  def initialize(options = {})
    @options = options
  end

  def scan(directory = '.')
    paths = Dir.entries(directory)
    paths.reject! { |entry| entry.start_with?('.') } unless @options[:a]
    paths.reverse! if @options[:r]
    paths.map { |path| FileInfo.new(File.join(directory, path)) }
  end
end
