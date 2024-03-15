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

  def format_permissions(mode)
    file_type = case mode & 0o170000
                when 0o040000 then 'd'
                when 0o020000 then 'c'
                when 0o060000 then 'b'
                when 0o100000 then '-'
                when 0o120000 then 'l'
                when 0o010000 then 'p'
                when 0o140000 then 's'
                else '?'
                end
    perms = mode.to_s(8)[-3, 3]
    readable_perms = perms.chars.map { |char| permission_char(char) }.join
    file_type + readable_perms
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
