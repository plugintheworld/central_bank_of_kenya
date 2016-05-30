# Central Bank of Kenya Historic Exchange Rates

Wraps a simple scraper to retrieve the historic exchange rates for Kenyanian Shilling (KES). Returns the average rates for yesterday or any day specified and supported by the Central Bank of Kenya.

## Install

Add this line to your application's Gemfile:

  ```ruby
  gem 'central_bank_of_kenya'
  ```

And then execute:

  ```ruby
  $ bundle
  ```

Or install it yourself as:

  ```ruby
  $ gem install central_bank_of_kenya
  ```

## Usage

### Initialize

  ```ruby
  xe = CentralBankOfKenya::HistoricRates.new as_of: Date.new(2015, 10, 24)
  xe.import! # => true
  ```

import! returns true if rates have been found. Might also throw HTTP errors. It will also return false when requesting rates for weekend days.

### Retrieve a specific rate

  ```ruby
  xe.rate('KES', 'EUR') # => 112.2322
  ```

Get all available currencies:

  ```ruby
  xe.currencies # => ['ZAR', 'USD', 'EUR', 'RWF'… ]
  ```

Get all rates

  ```ruby
  xe.rates # => { 'ZAR'=>6.4373, 'USD'=>100.6606, … }
  ```

## Legal

The author of this gem is not affiliated with the Central Bank of Kenya.

### License

GPLv3, see LICENSE file

### No Warranty

The Software is provided "as is" without warranty of any kind, either express or implied, including without limitation any implied warranties of condition, uninterrupted use, merchantability, fitness for a particular purpose, or non-infringement.
