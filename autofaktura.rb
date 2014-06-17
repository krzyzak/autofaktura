require "bundler/setup"
Bundler.require

require "active_support/core_ext/date/calculations"
require "active_support/core_ext/time/calculations"

require "./lib/report"
require "./lib/salary"
require "./lib/invoice"
require "./lib/infakt_invoice"
require "./lib/infakt_api"
Dotenv.load

start  = ask("Start:", Date) {|value| value.default = Date.today.prev_month.beginning_of_month.to_s }
finish = ask("Koniec:", Date){|value| value.default = Date.today.prev_month.end_of_month.to_s }

puts "Generuję raport..."

report = Report.new(from: start, to: finish)
salary = Salary.new(report: report)

table = Terminal::Table.new do |t|
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
puts table

validation = ["Y", "y", "\r"].include?(ask("Wygląda OK? (Y/n)"){|q| q.echo = false; q.character = true })
unless validation
  exit unless ["Y", "y", "\r"].include?(ask("Zapisać jako szkic? (Y/n)"){|q| q.echo = false; q.character = true })
end
draft = !validation

invoice_date  = ask("Data wystawienia faktury:", Date) {|value| value.default = Date.today.prev_month.end_of_month.to_s }
sale_date = ask("Data sprzedaży:", Date){|value| value.default = Date.today.to_s }

invoice_service = InfaktInvoice.new(salary: salary, invoice_date: invoice_date, sale_date: sale_date)
invoice = draft ? invoice_service.generate_draft : invoice_service.generate

table = Terminal::Table.new do |t|
  t << ["Numer faktury:", invoice.number]
  t << ["Data wystawienia:", invoice.invoice_date]
  t << ["Data sprzedaży:", invoice.sale_date]
  t << ["Wartość netto:", invoice.net]
  t << ["Kwota VAT:", invoice.vat]
  t << ["Wartość brutto:", invoice.gross]
end

puts table
