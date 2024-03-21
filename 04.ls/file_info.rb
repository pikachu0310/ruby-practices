# frozen_string_literal: true

class FileInfo
  attr_reader :path, :stat

  def initialize(path)
    @path = path
    @stat = File::Stat.new(path)
  end

  def filename
    File.basename(@path)
  end

  def details(widths)
    mode = format_permissions(@stat.mode).ljust(widths[:mode])
    nlink = nlink_str.rjust(widths[:nlink])
    owner = owner_name.ljust(widths[:owner])
    group = group_name.ljust(widths[:group])
    size = size_str.rjust(widths[:size])
    mtime = @stat.mtime.strftime('%b %e %H:%M').ljust(widths[:mtime])
    filename = File.basename(@path).ljust(widths[:filename])

    "#{mode} #{nlink} #{owner} #{group} #{size} #{mtime} #{filename}"
  end

  def nlink_str
    @stat.nlink.to_s
  end

  def owner_name
    Etc.getpwuid(@stat.uid).name
  end

  def group_name
    Etc.getgrgid(@stat.gid).name
  end

  def size_str
    @stat.size.to_s
  end

  private

  def format_permissions(mode)
    file_type_flags = {
      0o040000 => 'd',
      0o020000 => 'c',
      0o060000 => 'b',
      0o100000 => '-',
      0o120000 => 'l',
      0o010000 => 'p',
      0o140000 => 's'
    }

    file_type = file_type_flags[mode & 0o170000] || '?'
    perms_octal = mode.to_s(8)[-3, 3]
    readable_perms = perms_octal.chars.map { |char| permission_char(char) }.join

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
