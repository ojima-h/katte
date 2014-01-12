class Katte::Command::Exec
  date  = ARGV.shift
  files = ARGV.map {|path| FileTest.file? path }

  app = Katte.new(datetime: date)
  file.each {|file| app.exec file }
end
