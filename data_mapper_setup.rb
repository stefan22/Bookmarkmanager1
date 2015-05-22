require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require_relative './lib/link.rb'
require_relative './lib/tag.rb'
require_relative './lib/user.rb'

DataMapper.finalize
