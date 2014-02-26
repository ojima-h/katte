require 'katte/plugins/base'
require 'katte/plugins/file_type'
require 'katte/plugins/output'
require 'katte/plugins/node'

module Katte::Plugins
end

Dir[File.expand_path('../plugins/file_type/*.rb', __FILE__),
    File.expand_path('../plugins/output/*.rb'   , __FILE__),
    File.expand_path('../plugins/node/*.rb'     , __FILE__)].each {|p| require p }
