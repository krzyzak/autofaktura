class InfaktAPI
  include HTTParty
  base_uri "https://api.infakt.pl/v3/"
  attr_reader :salary

  def initialize(salary:)
    @salary = salary
  end

  def generate_invoice(invoice_date:, sale_date:, draft:)
    kind = draft ? "" : "vat"
    body = invoice_body(invoice_date: invoice_date, sale_date: sale_date, kind: kind)
    options = {headers: headers, body: body}

    invoice = self.class.post("/invoices", options)
    raise invoice.parsed_response.inspect unless invoice.code == 201
    invoice
  end

  def invoice_body(invoice_date:, sale_date:, kind:)
    {
      invoice: {
        payment_method: :transfer,
        number: number,
        check_duplicate_number: false,
        kind: kind,
        bank_name: bank_account[:name],
        bank_account: bank_account[:number],
        invoice_date: invoice_date,
        sale_date: sale_date,
        client_id: ENV["INFAKT_CLIENT_ID"],
        services: [service]
      }
    }
  end

  def number
    self.class.get("/invoices/next_number.json?kind=vat", {headers: headers})["next_number"]
  end

  def bank_account
    accounts = self.class.get("/bank_accounts", {headers: headers})
    {
      number: accounts["entities"][0]["account_number"],
      name: accounts["entities"][0]["bank_name"]
    }
  end
  private
  def headers
    {"X-inFakt-ApiKey" => ENV["INFAKT_API_KEY"]}
  end

  def service
    {
      name: ENV["SERVICE_NAME"],
      tax_symbol: 23,
      quantity: salary.computed_quantity,
      unit_net_price: salary.hour_rate * 100
    }
  end
end
