module Autofaktura
  class Report
    attr_reader :from, :to

    def initialize(from:, to:)
      @from = from
      @to = to
    end

    def total
      @total ||= harvest_report.inject(0){|total, report| total + report.hours.to_f }
    end

    private
    def harvest_report
      client.reports.time_by_user(harvest_id, from, to)
    end

    def client
      @client ||= Harvest.client(ENV["HARVEST_DOMAIN"], ENV["HARVEST_USER"], ENV["HARVEST_PASSWORD"])
    end

    def harvest_id
      client.account.who_am_i.id
    end
  end
end
