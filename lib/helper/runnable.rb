class Backup
  class Helper
    module Runnable
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def run
          new.run
        end
      end
    end
  end
end
