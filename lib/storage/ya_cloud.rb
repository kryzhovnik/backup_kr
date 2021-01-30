class Backup
  class Storage
    class YaCloud < S3
      END_POINT = 'https://storage.yandexcloud.net'

      def initialize
        @s3 = Aws::S3::Resource.new(
          endpoint: END_POINT,
          region: config.region,
          credentials: credentials
        )
        @bucket = @s3.bucket(config.bucket)
        @prefix = config.prefix || ''
      end
    end
  end
end
