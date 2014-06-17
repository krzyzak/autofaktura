module Autofaktura
  class CLI
    attr_reader :invoice

    def run
      display_overview
      confirm_overview
      if create_draft?
        create_draft!
      else
        create_invoice!
      end
      display_invoice
      confirm_invoice
      send_invoice
    end

    def display_overview
      @overview_table ||= Terminal::Table.new do |t|
        t << ["Liczba harvestocoinów", report.total]
        t << ["Liczba harvestocoinów (z bonusami)", salary.computed_quantity]
        t << :separator
        t << ["Stawka godzinowa", salary.hour_rate]
        t << :separator
        t << ["Bonusy netto", salary.net_bonus]
        t << ["Bonusy brutto", salary.gross_bonus]
        t << ["Bonusy w harvestocoinach", (salary.computed_quantity - report.total).round(2)]
        t << :separator
        t << ["Suma netto", salary.net]
        t << ["Suma brutto", salary.gross]
      end

      puts @overview_table
    end

    def display_invoice
      @invoice_table ||= Terminal::Table.new do |t|
        t << ["Numer faktury:", invoice.number]
        t << ["Data wystawienia:", invoice.invoice_date]
        t << ["Data sprzedaży:", invoice.sale_date]
        t << ["Wartość netto:", invoice.net]
        t << ["Kwota VAT:", invoice.vat]
        t << ["Wartość brutto:", invoice.gross]
      end

      puts @invoice_table
    end

    def confirm_overview
      confirm_draft_creation unless bool_question("Wygląda OK? (Y/n)")
    end

    def confirm_draft_creation
      exit unless bool_question("Zapisać jako szkic? (Y/n)")
      @draft = true
    end

    def confirm_invoice
      bool_question("Wysłać Fakturę do klienta? (Y/n)")
    end

    def create_draft?
      !!@draft
    end

    def create_draft!
      @invoice = invoice_service.generate_draft
    end

    def create_invoice!
      @invoice = invoice_service.generate
    end

    def send_invoice
      invoice_service.send
    end
    private
    def bool_question(question)
      ["Y", "y", "\r"].include?(ask(question){|q| q.echo = false; q.character = true })
    end

    def from
      @from ||= ask("Start:", Date){|value| value.default = Date.today.prev_month.beginning_of_month.to_s }
    end

    def to
      @to ||= ask("Koniec:", Date){|value| value.default = Date.today.prev_month.end_of_month.to_s }
    end

    def sale_date
      @sale_date ||= ask("Data sprzedaży:", Date){|value| value.default = Date.today.to_s }
    end

    def invoice_date
      @invoice_date ||= ask("Data wystawienia faktury:", Date) {|value| value.default = Date.today.prev_month.end_of_month.to_s }
    end

    def report
      @report ||= Report.new(from: from, to: to)
    end

    def salary
      @salary ||= Salary.new(report: report)
    end

    def invoice_service
      @invoice_service ||= InfaktInvoice.new(salary: salary, invoice_date: invoice_date, sale_date: sale_date)
    end
  end
end
