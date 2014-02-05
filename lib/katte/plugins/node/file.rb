class Katte::Plugins::Node
  class File_ < Katte::Plugins::Node
    name 'file'

    def duration; 30; end
    
    def add_child(node, *params)
      file = params.first
      return unless file
      add_watch_list(file, node)
    end

    def run(driver)
      until watching_files.empty?
        update_watch_list do |file, nodes|
          if FileTest.exist? file
            nodes.each {|n| driver.next(self, n.name) }
            true
          else
            false
          end
        end
        sleep duration * 60 unless watching_files.empty?
      end
          
      driver.done(self)
    end

    private
    def watching_files
      (@watch_list || {}).keys
    end
    def add_watch_list(file, node)
      @watch_list ||= {}
      (@watch_list[file] ||= []) << node
    end
    def update_watch_list(&proc)
      @watch_list ||= {}
      @watch_list = @watch_list.reject(&proc)
    end
  end
end
