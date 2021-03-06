class Backup
  class Storage
    class S3 < Base
      attr_reader :bucket, :prefix

      def initialize
        @s3 = Aws::S3::Resource.new(
          region: config.region,
          credentials: credentials
        )
        @bucket = @s3.bucket(config.bucket)
        @prefix = config.prefix || ''
      end

      def save(source)
        name = self.class.name.split("::").last
        Backup.log("Starting copy the backup to #{name}")

        filename = File.basename(source)
        year = Time.now.year.to_s

        path = prefix.empty? ? year : File.join(prefix, year)
        key = File.join(path, filename)
        bucket.object(key).upload_file(source)

        clean!
        Backup.log("Finished with #{name}")
      end

      def clean!
        items = bucket.objects(prefix: prefix).map { |item| item }

        cleaner = CleanStrategy.new(config.keep)
        cleaner.select_to_clean(items).each do |object|
          object.delete
        end
      end

      private
        def credentials
          ::Aws::Credentials.new(config.access_key_id, config.secret_access_key)
        end

      class CleanStrategy
        attr_reader :opts

        def initialize(opts={})
          @opts = opts
        end

        def select_to_clean(items)
          keep = Set.new
          if last = opts[:last]
            keep += items.sort_by(&:last_modified).reverse[0..(last-1)]
          end

          case opts[:one_in]
          when :every_month
            by_month = items.group_by do |item|
              item.last_modified.strftime('%Y%m')
            end
            keep += by_month.values.map(&:first)
          end

          items - keep.to_a
        end
      end
    end
  end
end
