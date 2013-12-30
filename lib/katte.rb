require 'logger'
require 'katte/config'
require 'katte/command/shell'

class Katte
  def self.config
    @config ||= Katte::Config.new
  end

  def self.command_map(extname)
    case extname
    when 'sh' then Command::Shell
    else nil
    end
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.run
    nodes = []
    Find.find(@config.recipes_root) do |f|
      name = Pathname.new(f).relative_path_from(@config.recipes_root)

      nodes << Node::Factory::Base.create(name)
    end
  end
end
