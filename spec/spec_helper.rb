require 'bundler'

ENV['KATTE_MODE'] = 'test'
APP_PATH = File.expand_path('..', __FILE__)

Bundler.require(:default, :test)

