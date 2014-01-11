class Katte::Plugins::Output
  class File_ < Katte::Plugins::Output
    name :file

    def call(node)
      out_file = File.join(Katte.app.config.result_root, node.name, app.env.to_hash['date'] + ".txt")
      err_file = File.join(Katte.app.config.log_root   , node.name, app.env.to_hash['date'] + ".txt")

      [out_file, err_file].each {|f| FileUtils.makedirs(File.dirname(f)) }

      File.open(out_file, 'w') {|out|
        File.open(err_file, 'a') {|err|
          yield out, err
        }
      }
    end
  end
end
