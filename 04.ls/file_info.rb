# frozen_string_literal: true

class FileInfo
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def details
    stat = File::Stat.new(path)
    "#{permissions(stat)} #{stat.nlink} #{stat.uid} #{stat.gid} #{stat.size} #{stat.mtime} #{File.basename(path)}"
  end

  private

  def permissions(stat)
    mode = stat.mode.to_s(8)[-3, 3]
    mode.chars.map { |char| permission_char(char) }.join
  end

  def permission_char(char)
    case char
    when '0' then '---'
    when '1' then '--x'
    when '2' then '-w-'
    when '3' then '-wx'
    when '4' then 'r--'
    when '5' then 'r-x'
    when '6' then 'rw-'
    when '7' then 'rwx'
    else '---'
    end
  end
end
