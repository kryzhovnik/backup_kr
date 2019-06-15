class Backup
  class Database
    class Base
      attr_reader :config

      def initialize(&block)
        @config ||= OpenStruct.new
        yield @config
      end

      def run
        raise NotImplementedError
      end
    end
  end
end
