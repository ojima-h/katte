require 'rspec'
require 'debugger'

require 'katte'

ENV['KATTE_ENV'] = 'test'
APP_PATH = File.expand_path('..', __FILE__)
