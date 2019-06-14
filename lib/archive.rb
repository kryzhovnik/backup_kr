class Backup
  class Archive
    attr_reader :name, :paths

    def initialize(name=nil, &block)
      @name = sanitize_dirname(name.to_s) if name
      @paths = []
      yield self
    end

    def add(path)
      @paths << path
    end

    def run
      current_path = Pathname.new(Dir.pwd)
      if name
        dest = current_path / name
        FileUtils.mkdir_p(dest)
      else
        dest = current_path
      end

      @paths.each do |path|
        system "cp -r #{path} #{dest}"
      end
    end

    private
      def mkdir(path)
        FileUtils.mkdir_p(path)
      end

      def sanitize_dirname(name)
        name.gsub(/[^0-9A-Z]/i, '_')
      end
  end
end
