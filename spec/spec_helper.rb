require 'bundler'
Bundler.require(:default, :test)

ENV['KATTE_MODE'] = 'test'

require 'katte'
require 'katte/debug'

APP_PATH = File.expand_path('..', __FILE__)
