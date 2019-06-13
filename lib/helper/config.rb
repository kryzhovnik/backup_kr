class Backup
  class Helper
    module Config
      def self.included(klass)
        klass.extend ClassMethods
      end

      def config
        self.class.instance_variable_get(:@config)
      end

      module ClassMethods
        def config
          @config ||= OpenStruct.new
          if block_given?
            yield @config
          else
            @config
          end
        end
      end
    end
  end
end
