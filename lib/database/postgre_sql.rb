class Backup
  class Database
    class PostgreSQL < Base
      def command
        dbname = config.name
        username = config.username
        password = config.password
        host = config.host
        port = config.port
        opts = config.additional_options.join(' ') if config.additional_options
        file = "#{dbname}.db"

        command =  "pg_dump"
        command += " --dbname=postgresql://#{username}:#{password}@#{host}:#{port}/#{dbname}"
        command + " #{opts} > #{file}"
      end
    end
  end
end
