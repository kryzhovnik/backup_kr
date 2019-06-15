class Backup
  class Database
    class PostgreSQL < Base
      # include Helper::Config
      # include Helper::Runnable

      def run
        dbname = config.name
        username = config.username
        password = config.password
        host = config.host
        port = config.port
        opts = config.additional_options.join(' ')
        file = "#{dbname}.db"

        command =  "pg_dump"
        command += " --dbname=postgresql://#{username}:#{password}@#{host}:#{port}/#{dbname}"
        command += " #{opts} > #{file}"

        system(command) or raise CommandError.new(command)
      end
    end
  end
end
