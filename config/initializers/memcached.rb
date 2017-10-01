require 'dalli'

CACHE = Dalli::Client.new('127.0.0.1', { :namespace => 'markets', :socket_timeout => 3, :compress => true })