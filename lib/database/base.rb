class Backup
  class Database
    class Base
      attr_reader :config

      def initialize(&block)
        @config ||= OpenStruct.new
        yield @config
      end

      def run
        name = self.class.name.split("::").last
        Backup.log("Starting backup #{name}")
        cmd = command
        system(cmd) or raise CommandError.new(cmd)
        Backup.log("Finished backuping #{name}")
      end
    end
  end
end
