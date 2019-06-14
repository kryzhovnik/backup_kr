class Backup
  class CommandError < StandardError
    def initialize(command)
      msg = "\"#{command}\" returned non zero exit status"
      super(msg)
    end
  end
end
