class InfaktInvoice
  attr_reader :invoice_date, :sale_date

  def initialize(salary: salary, invoice_date:, sale_date:)
    @salary = salary
    @invoice_date = invoice_date
    @sale_date = sale_date
  end

  def generate
    invoice(draft: false)
  end

  def generate_draft
    invoice(draft: true)
  end
  private
  def invoice(draft:)
    Invoice.new(api.generate_invoice(invoice_date: invoice_date, sale_date: sale_date, draft: draft))
  end

  def api
    @api ||= InfaktAPI.new(salary: @salary)
  end
end
