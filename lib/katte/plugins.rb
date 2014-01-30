require 'katte/plugins/base'
require 'katte/plugins/file_type'
require 'katte/plugins/output'
require 'katte/plugins/node'

class Katte
  class Plugins
    def self.file_type; FileType.plugins; end
    def self.output   ; Output.plugins  ; end
    def self.node     ; Node.plugins    ; end
  end
end

Dir[File.expand_path('../plugins/file_type/*.rb', __FILE__),
    File.expand_path('../plugins/output/*.rb'   , __FILE__),
    File.expand_path('../plugins/node/*.rb'     , __FILE__)].each {|p| require p }
