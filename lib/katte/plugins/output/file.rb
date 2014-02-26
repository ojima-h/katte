require 'fileutils'

class Katte::Plugins::Output::File_
  include Katte::Plugins::Output
  name :file

  def out(node, data)
    return data if data.empty?

    file = File.join(Katte.app.config.result_root,
                     node.name + '.out',
                     Katte.app.env.to_hash['date'] + ".txt")

    FileUtils.makedirs(File.dirname(file))

    File.open(file, 'w') {|f| f.print data }
  end

  def err(node, data)
    return data if data.empty?

    file = File.join(Katte.app.config.log_root,
                     'recipes',
                     node.name + '.log',
                     Katte.app.env.to_hash['date'] + ".txt")

    FileUtils.makedirs(File.dirname(file))

    File.open(file, 'a') {|f| f.print data }
  end
end
