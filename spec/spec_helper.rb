require 'bundler'
Bundler.require(:default, :test)

ENV['KATTE_MODE'] = 'test'

require 'katte'

APP_PATH = File.expand_path('..', __FILE__)
