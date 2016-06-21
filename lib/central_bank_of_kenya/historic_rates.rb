require 'date'

module CentralBankOfKenya
  class HistoricRates
    attr_reader :as_of
    attr_accessor :rate_scraper

    def initialize options = {}
      @as_of = options[:as_of] || date_yesterday
    end

    def rate(iso_from, iso_to)
      fail_unless_rates_present

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
      fail_unless_rates_present
      @rates.keys
    end

    # Returns all rates imported
    def rates
      fail_unless_rates_present
      @rates
    end

    # Returns true when reading the website was successful
    def has_rates?
      !@rates.nil? && !@rates.empty?
    end

    # Triggers the scraping
    def import!
      @rates = rate_scraper.call(@as_of)
      has_rates?
    end

    private

    def date_yesterday
      Date.today - 1
    end

    def fail_unless_rates_present
      fail MissingRates unless has_rates?
    end

    def rate_scraper
      @rate_scraper ||= CentralBankOfKenya::RateScraper.new
    end
  end
end
