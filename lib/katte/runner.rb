class Katte
  class Runner
    def run
      load_nodes

      connect_nodes

      execute

      print_summary
    end

    def initialize
    end

    def load_nodes
      @nodes = Katte::Node::Collection.new
      (builtin_nodes + recipe_nodes).each {|node| @nodes << node }
    end
    def builtin_nodes
      Plugins::Node.plugins.values
    end
    def recipe_nodes
      node_factory = Katte.app.config.factory || Katte::Recipe::NodeFactory.new
      Find.find(Katte.app.config.recipes_root).select {|file|
        File.file? file
      }.map {|file|
        node_factory.load(file)
      }
    end

    def connect_nodes
      @nodes.connect
    end

    def execute
      @summary = Driver.run(@nodes)
    end

    def print_summary
      return if Katte.app.config.mode == 'test'

      summray_log_file = File.join(Katte.app.config.log_root, 'summary.log')
      File.open(summray_log_file, 'w') do |file|
        file.print <<-EOF
Summary:
  success: #{@summary[:success].length}
  fail:    #{@summary[:fail].length}
  skip:    #{@summary[:skip].length}
        EOF
      end

      failed_log_file = File.join(Katte.app.config.log_root, 'failed.log')
      File.open(failed_log_file, 'w') do |file|
        @summary[:fail].each do |node|
          file.puts node.name
        end
      end
    end
  end
end
