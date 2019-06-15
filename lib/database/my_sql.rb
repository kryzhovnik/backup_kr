class Backup
  class Database
    class MySQL < Base
      # include Helper::Config
      # include Helper::Runnable

      def command
        dbname = config.name
        username = config.username
        password = config.password
        host = config.host
        port = config.port
        opts = config.additional_options.join(' ') if config.additional_options
        file = "#{dbname}.db"

        command = ["mysqldump #{dbname}"]
        command << "--host=#{host}" if host
        command << "--port=#{port}" if port
        command << "--user=#{username}" if username
        command << "--password=#{password}" if password
        command << "#{opts} > #{file}"
        command.join(' ')
      end
    end
  end
end
