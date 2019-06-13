class Backup
  class Storage
    class Base
      include Helper::Config

      def save(source)
        raise NotImplementedError
      end
    end
  end
end
