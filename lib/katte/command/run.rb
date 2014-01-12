class Katte::Command::Run
  date = ARGV.shift

  app = Katte.new(datetime: date)
  app.run
end
