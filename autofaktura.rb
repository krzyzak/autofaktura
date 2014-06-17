require "bundler/setup"
Bundler.require

require "active_support/core_ext/date/calculations"
require "active_support/core_ext/time/calculations"
require "./lib/autofaktura"

Dotenv.load

Autofaktura::CLI.new.run
