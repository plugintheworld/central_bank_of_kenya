require 'nokogiri'
require 'uri'
require 'net/http'
require 'date'
require 'pry'

module CentralBankOfKenya
  class MissingRates < StandardError; end

  TRANSLATE = { 'US DOLLAR'         => 'USD',
                'STG POUND'         => 'GBP',
                'EURO'              => 'EUR',
                'SA RAND'           => 'ZAR',
                'KES / USHS'        => 'UGX',
                'KES / TSHS'        => 'TZS',
                'KES / RWF'         => 'RWF',
                'KES / BIF'         => 'BIF',
                'AE DIRHAM'         => 'AED',
                'CAN $'             => 'CAD',
                'S FRANC'           => 'CHF',
                'JPY (100)'         => 'JPY',
                'SW KRONER'         => 'SEK',
                'NOR KRONER'        => 'NOK',
                'DAN KRONER'        => 'DKK',
                'IND RUPEE'         => 'INR',
                'HONGKONG DOLLAR'   => 'HKD',
                'SINGAPORE DOLLAR'  => 'SGD',
                'SAUDI RIYAL'       => 'SAR',
                'CHINESE YUAN'      => 'CNY',
                'AUSTRALIAN $'      => 'AUD'}

  class HistoricRates
    attr_reader :as_of

    def initialize options = {}
      @as_of = options[:as_of] || Date.yesterday
    end

    def rate(iso_from, iso_to)
      fail MissingRates unless has_rates?

      if iso_from == 'KES'
        rates[iso_to] ? 1/rates[iso_to] : nil
      elsif iso_to == 'KES'
        rates[iso_from]
      else
        nil
      end
    end

    # Returns a list of ISO currencies
    def currencies
      fail MissingRates unless has_rates?
      @rates.keys
    end

    # Returns all rates returned
    def rates
      fail MissingRates unless has_rates?
      @rates
    end

    # Returns true when reading the website was successful
    def has_rates?
      !@rates.nil? && !@rates.empty?
    end

    # Triggers the scraping
    def import!
      @rates = scrape(@as_of)
      has_rates?
    end

    def scrape as_of
      self.class.scrape(@as_of)
    end

    # Scrapes the RNB website for the historic exchange rates of a given day
    def self.scrape as_of
      uri = URI('https://www.centralbank.go.ke/index.php/rate-and-statistics/exchange-rates-2')

      params = {
        'date'    => as_of.strftime('%d'),
        'month'   => as_of.strftime('%m').upcase,
        'year'    => as_of.strftime('%Y'),
        'tdate'   => as_of.strftime('%d'),
        'tmonth'  => as_of.strftime('%m').upcase,
        'tyear'   => as_of.strftime('%Y'),
        'currency' => '',
        'searchForex' => 'Search'
      }

      response = Net::HTTP.post_form(uri, params)
      dom = Nokogiri::HTML(response.body)
      rows = dom.css('#cont1 > #cont3 > div.item-page > #interbank > table > tr > td > table > tr')# will always return an []

      Hash[rows.map do |row|
        currency = TRANSLATE[row.css(':nth-child(2)').text]
        next if currency.nil?
        next if currency.empty?
        avrg = row.css(':nth-child(5)').text
        next if avrg.nil?
        next if avrg.empty?

        [currency, Float(avrg)] rescue nil
      end.compact]
    end
  end
end
