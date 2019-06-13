class Backup
  class Runner
    attr_reader :notifier, :storage

    def initialize(setup)
      @setup = setup
      @notifier = @setup.notifier.new
      @storage = @setup.storage.new
    end

    def run
      @dir = prepare_dir
      run_databases
      @compressed = run_compression
      save_to_storage
    rescue => exception
      notify_fail(exception)
      raise exception
    ensure
      clean
    end

    private
      def prepare_dir
        timestamp = Time.now.strftime('%Y%m%d-%H%M')
        dir = File.join(@setup.dir, timestamp)
        FileUtils.mkdir_p(dir)
        Dir.chdir dir
        dir
      end

      def run_databases
        @setup.databases.each(&:run)
      end

      def run_compression
        Compressor.compress(@dir)
      end

      def save_to_storage
        storage.save(@compressed)
      end

      def notify_fail(exception)
        body = "The error: #{exception.message}"
        body += "\n\n\tBacktrace:\n\n\t"
        body += exception.backtrace.join("\n\t")

        notifier.deliver(
          subject: "Backup failed with #{exception.message}",
          body: body
        )
      end

      def clean
        FileUtils.rm(@compressed) if @compressed && File.exists?(@compressed)
        FileUtils.rm_r(@dir) if File.exists?(@dir)
      end
  end
end
