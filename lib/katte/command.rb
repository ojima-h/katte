require 'katte'
require 'date'
require 'optparse'

class Katte
  class Command
    command = ARGV.shift

    options = {
      date: (Date.today - 1).strftime("%Y-%m-%d")
    }

    opt = OptionParser.new
    opt.on('-d date') {|v| options[:date] = v }
    opt.banner = "katte <command> [options]"
    opt.parse!(ARGV)

    files = ARGV.select(&FileTest.method(:file?))
                .map(&File.method(:absolute_path))

    case command
    when 'run'
      app = Katte.new(datetime: options[:date])

      if files.empty?
        app.run
      else
        files.each {|file| app.exec file }
      end

    else
      print opt.help
      print <<-EOH

command:
  run   Execute recipes.
        EOH
    end
  end
end
