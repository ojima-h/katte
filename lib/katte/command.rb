require 'katte'
require 'date'
require 'optparse'

class Katte
  class Command
    opt = OptionParser.new
    opt.on('-d date') {|v| options[:datetime] = v }
    opt.on('-v')      { options[:verbose] = true }
    opt.on('-h')      { print_help_message; exit }
    opt.banner = "katte [options] [files]"
    opt.parse!(ARGV)

    files = ARGV.select(&FileTest.method(:file?))
                .map(&File.method(:absolute_path))
    options = {
      :date  => (Date.today - 1).strftime("%Y-%m-%d"),
      :files => files,
    }

    app = Katte.new(options)

    if files.empty?
      app.run
    else
      files.each {|file| app.exec file }
    end

    def print_help_message
      print opt.help
    end
  end
end
