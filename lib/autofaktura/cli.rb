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
      send_invoice if confirm_invoice
    end

    def display_overview
      @overview_table ||= Terminal::Table.new do |t|
        t << ["Liczba harvestocoinów".bold, report.total]
        t << ["Liczba harvestocoinów (z bonusami)".bold, salary.computed_quantity]
        t << :separator
        t << ["Stawka godzinowa".bold, salary.hour_rate]
        t << :separator
        t << ["Bonusy netto".bold, salary.net_bonus]
        t << ["Bonusy brutto".bold, salary.gross_bonus]
        t << ["Bonusy w harvestocoinach".bold, (salary.computed_quantity - report.total).round(2)]
        t << :separator
        t << ["Suma netto".bold.red, salary.net.to_s.red]
        t << ["Suma brutto".bold.green, salary.gross.to_s.green]
      end

      puts @overview_table
    end

    def display_invoice
      @invoice_table ||= Terminal::Table.new do |t|
        t << ["Numer faktury:".bold, invoice.number]
        t << ["Data wystawienia:", invoice.invoice_date]
        t << ["Data sprzedaży:", invoice.sale_date]
        t << ["Wartość netto:".bold.red, invoice.net.red]
        t << ["Kwota VAT:".bold.yellow, invoice.vat.yellow]
        t << ["Wartość brutto:".bold.green, invoice.gross.green]
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
      bool_question("Wysłać Fakturę do klienta? (Y/n)") unless create_draft?
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
      ["Y", "y", "\r"].include?(ask(question){|q| q.echo = false; q.character = true; q.default = "Y" })
    end

    def from
      @from ||= ask("Start:", Date){|value| value.default = default_from_date.to_s }
    end

    def to
      @to ||= ask("Koniec:", Date){|value| value.default = default_to_date.to_s }
    end

    def sale_date
      @sale_date ||= ask("Data sprzedaży:", Date){|value| value.default = Date.today.to_s }
    end

    def invoice_date
      @invoice_date ||= ask("Data wystawienia faktury:", Date) {|value| value.default = default_invoice_date.to_s }
    end

    def first_half_of_month?
      Date.today.day.to_f / Date.today.end_of_month.day.to_f < 0.5
    end

    def default_from_date
      first_half_of_month? ? beginning_of_previous_month : beginning_of_month
    end

    def default_to_date
      first_half_of_month? ? end_of_previous_month : end_of_month
    end

    def default_invoice_date
      first_half_of_month? ? end_of_previous_month : today
    end

    def beginning_of_month
      today.beginning_of_month
    end

    def beginning_of_previous_month
      today.prev_month.beginning_of_month
    end

    def end_of_month
      today.end_of_month
    end

    def end_of_previous_month
      today.prev_month.end_of_month
    end

    def today
      Date.today
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
