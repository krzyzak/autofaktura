# Autofaktura

This small CLI application is used for automatical invoice generation.
It fetches timesheet from your time tracker application (currently it works with Harvest only), and then gives you ability to generate that invoice (currently only inFakt API is supported).
You can create VAT invoice, as well as draft, which you can modify later.
If you wish, there’s also way to automatically send such invoice to your contractor.

## Installation & Usage

1. Clone this app (```git clone https://github.com/krzyzak/autofaktura.git```)
2. Bundle it (```bundle```)
3. Configure it (```mv .env.example .env```, then edit ```.env``` file with your favourite editor)
3. Run it (```ruby autofaktura.rb```)


## Contributing

1. Fork it ( https://github.com/[my-github-username]/road_runner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
