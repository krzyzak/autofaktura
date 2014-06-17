# Autofaktura

This small CLI application is used for automatical invoice generation.
It fetches timesheet from your time tracker application (currently it works with Harvest only), and then gives you ability to generate that invoice (currently only inFakt API is supported).
You can create VAT invoice, as well as draft, which you can modify later.
If you wish, there’s also way to automatically send such invoice to your contractor.

## Installation & Usage

1. Clone this app (```git clone https://github.com/krzyzak/autofaktura.git```)
2. Bundle it (```bundle```)
3. Configure it (```mv .env.example .env```, then edit ```.env``` file with your favourite editor) – see Configuration section
3. Run it (```ruby autofaktura.rb```)

## Interface 
Autofaktura has very simple CLI interface. It uses smart defaults, so it tries to guess all dates needed to generate invoice.
On the other hand, it doesn’t try to be too smart, so your confirmation is always required to generate&send invoice.
![cli interface](http://cl.ly/image/3C2O1q0g3841/autofaktura.png "CLI interface")


## Configuration

Configuration is pretty straightforward – just edit your ```.env``` file.
Here are some options which might not be clear:
* ```INFAKT_CLIENT_EMAIL``` – Clients’ default email will be used, unless you specify other here.
* ```NET_BONUS=0``` – If you have any constant bonus (perhaps base salary?), which you want to apply to invoice before taxation, put it here.
* GROSS_BONUS=0``` – If you have any constant bonus, which is already calculated after taxation, put it here.
## Contributing

1. Fork it ( https://github.com/[my-github-username]/road_runner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
