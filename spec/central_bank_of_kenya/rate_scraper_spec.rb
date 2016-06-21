require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CentralBankOfKenya::RateScraper do
  let(:rate_scraper) { CentralBankOfKenya::RateScraper.new }
  let(:valid_date) { Date.new(2016, 06, 16) }

  describe '#call' do
    context 'when the scraper is successful', :vcr do
      subject { rate_scraper.call(valid_date) }
      it { should be_a_kind_of(Hash) }
      it { should include('GBP', 'EUR', 'USD') }
    end

    context 'when the scraper fails', :vcr do
      before do
        rate_scraper.form_url = invalid_url
      end
      subject { rate_scraper.call(valid_date) }
      it { should be_a_kind_of(Hash) }
      it { should_not include('GBP', 'EUR', 'USD') }
    end
  end

  def invalid_url
    'https://www.centralbank.go.ke/index.php/rate-and-statistics/exchange-rates-0'
  end
end
