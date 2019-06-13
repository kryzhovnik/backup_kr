class Backup
  class Notifier
    class Mail
      include Helper::Config

      attr_reader :server, :port,
                  :domain, :user_name, :password, :authentication,
                  :from, :to

      def initialize
        @server          = config.server
        @port            = config.port
        @domain          = config.domain
        @user_name       = config.user_name
        @password        = config.password
        @authentication  = config.authentication
        @from            = config.from
        @to              = config.to
      end

      def deliver(subject:, body:)
        msg = concat_message(subject, body)

        Net::SMTP.start(server, port, domain,
          user_name, password, authentication) do |smtp|

          smtp.send_message msg, from, to
        end
      end

      private
        def concat_message(subject, body)
          time = Time.now.rfc2822

          msg =  "From: <#{from}>\n"
          msg += "To: <#{to}>\n"
          msg += "Subject: #{subject}\n"
          msg += "Date: #{time}\n\n"
          msg + body
        end
    end
  end
end
