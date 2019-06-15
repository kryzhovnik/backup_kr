class Backup
  class Compressor
    def self.compress(path)
      Backup.log("Start compressing")
      source = Pathname.new(path)
      base, dest = source.split
      filename = dest.to_s.sub(/\/$/, '') + '.tar.gz'

      Dir.chdir base

      command = "tar czf #{filename} #{dest}"
      if system(command)
        base + filename
      else
        raise CommandError.new(command)
      end
      Backup.log("Compressed")
    end
  end
end
