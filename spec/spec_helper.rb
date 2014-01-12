require 'bundler'
Bundler.require(:default, :test)

ENV['KATTE_MODE'] = 'test'

APP_PATH = File.expand_path('..', __FILE__)

require 'katte'

