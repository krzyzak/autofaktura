class Invoice
  def initialize(data)
    @data = data
  end

  def id
    @data["id"]
  end

  def sale_date
    @data["sale_date"]
  end

  def invoice_date
    @data["invoice_date"]
  end

  def number
    @data["number"]
  end

  def net
    to_price(@data["net_price"])
  end

  def gross
    to_price(@data["gross_price"])
  end

  def vat
    to_price(@data["tax_price"])
  end

  private
  def to_price(value)
    [value/100, "PLN"].join(" ")
  end
end
