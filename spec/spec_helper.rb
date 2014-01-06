ENV['KATTE_MODE'] = 'test'

require 'bundler'
Bundler.require(:default, :test)

require 'rspec'
require 'debugger'

require 'katte'

APP_PATH = File.expand_path('..', __FILE__)
