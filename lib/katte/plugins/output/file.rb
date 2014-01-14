require 'fileutils'

class Katte::Plugins::Output
  class File_ < Katte::Plugins::Output
    name :file

    def out(node, data)
      file = File.join(Katte.app.config.result_root,
                       node.name,
                       Katte.app.env.to_hash['date'] + ".txt")

      FileUtils.makedirs(File.dirname(file))

      File.open(file, 'w') {|f| f.print data }
    end

    def err(node, data)
      file = File.join(Katte.app.config.log_root, node.name, Katte.app.env.to_hash['date'] + ".txt")

      FileUtils.makedirs(File.dirname(file))

      File.open(file, 'a') {|f| f.print data }
    end
  end
end
