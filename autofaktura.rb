require "bundler/setup"
Bundler.require

require "active_support/core_ext/date/calculations"
require "active_support/core_ext/time/calculations"

require "./lib/report"
require "./lib/salary"
require "./lib/invoice"
require "./lib/infakt_invoice"
require "./lib/infakt_api"
require "./lib/cli"
Dotenv.load

CLI.new.run
