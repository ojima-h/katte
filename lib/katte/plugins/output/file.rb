class Katte::Plugins::Output
  class File_ < Katte::Plugins::Output
    name :file

    def out(node, stream)
      file = File.join(Katte.app.config.result_root, node.name, app.env.to_hash['date'] + ".txt")

      FileUtils.makedirs(File.dirname(file))

      File.open(file, 'w') {|out|
        stream.each {|line| out << line }
      }
    end

    def err(node, stream)
      file = File.join(Katte.app.config.log_root, node.name, app.env.to_hash['date'] + ".txt")

      FileUtils.makedirs(File.dirname(file))

      File.open(file, 'a') {|out|
        stream.each {|line| out << line }
      }
    end
  end
end
