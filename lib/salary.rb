class Salary
  attr_reader :report

  def initialize(report:)
    @report = report
  end

  def hour_rate
    Float(ENV["HOUR_RATE"])
  end

  def net_bonus
    Float(ENV["NET_BONUS"])
  end

  def gross_bonus
    Float(ENV["GROSS_BONUS"])
  end

  def vat
    1.23
  end

  def net
    ((report.total * hour_rate) + net_bonus).round(2)
  end

  def gross
    (net * vat + gross_bonus).round(2)
  end

  def computed_quantity
    ((gross * gross_to_net) / hour_rate).round(2)
  end

  def gross_to_net
    (100/(vat*100))
  end
end
