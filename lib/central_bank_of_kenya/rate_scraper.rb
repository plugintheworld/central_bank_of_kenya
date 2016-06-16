require 'nokogiri'
require 'uri'
require 'net/http'

module CentralBankOfKenya
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


  class RateScraper
    attr_reader :start_date
    attr_accessor :form_url

    def initialize
    end

    def call start_date
      @start_date = start_date

      rates
    end

    private

    def rates
      response = Net::HTTP.post_form(URI(form_url), form_params)
      dom = Nokogiri::HTML(response.body)
      rows = dom.css(element_matcher)

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

    def form_url
      @form_url ||= 'https://www.centralbank.go.ke/index.php/rate-and-statistics/exchange-rates-2'
    end

    def form_params
      {
        'date'    => start_date.strftime('%d'),
        'month'   => start_date.strftime('%m').upcase,
        'year'    => start_date.strftime('%Y'),
        'tdate'   => start_date.strftime('%d'),
        'tmonth'  => start_date.strftime('%m').upcase,
        'tyear'   => start_date.strftime('%Y'),
        'currency' => '',
        'searchForex' => 'Search'
      }
    end

    def element_matcher
      '#cont1 > #cont3 > div.item-page > #interbank > table > tr > td > table > tr'
    end
  end
end
