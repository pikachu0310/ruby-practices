# frozen_string_literal: true

class FileInfo
  attr_reader :path, :stat

  def initialize(path)
    @path = path
    @stat = File::Stat.new(path)
  end

  def details(widths)
    mode = format_permissions(@stat.mode).ljust(widths[:mode])
    nlink = @stat.nlink.to_s.rjust(widths[:nlink])
    owner = Etc.getpwuid(@stat.uid).name.ljust(widths[:owner])
    group = Etc.getgrgid(@stat.gid).name.ljust(widths[:group])
    size = @stat.size.to_s.rjust(widths[:size])
    mtime = @stat.mtime.strftime('%b %e %H:%M').ljust(widths[:mtime])
    filename = File.basename(@path).ljust(widths[:filename])

    "#{mode} #{nlink} #{owner} #{group} #{size} #{mtime} #{filename}"
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
    {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }.fetch(char, '---')
  end
end
