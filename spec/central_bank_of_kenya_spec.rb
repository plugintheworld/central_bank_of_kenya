require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CentralBankOfKenya::HistoricRates do
  DEC1_RATES = {
    'USD' => 100.6606,
    'GBP' => 147.3558,
    'EUR' => 112.2322,
    'ZAR' => 6.4373,
    'UGX' => 33.4293,
    'TZS' => 21.7464,
    'RWF' => 7.4161,
    'BIF' => 15.4482,
    'AED' => 27.4059,
    'CAD' => 77.1434,
    'CHF' => 101.4826,
    'JPY' => 91.6638,
    'SEK' => 12.0901,
    'NOK' => 12.0901,
    'DKK' => 15.0879,
    'INR' => 1.5041,
    'HKD' => 12.9632,
    'SGD' => 73.1678,
    'SAR' => 26.8410,
    'CNY' => 15.3335,
    'AUD' => 72.4404
  }

  let(:dec1) do
    bot = CentralBankOfKenya::HistoricRates.new as_of: Date.new(2016, 5, 30)
    allow(bot).to receive(:scrape).and_return(DEC1_RATES)
    bot
  end

  let(:future) do
    bot = CentralBankOfKenya::HistoricRates.new as_of: Date.new(2039, 2, 1)
    allow(bot).to receive(:scrape).and_return({})
    bot
  end

  describe '.import!' do
    it 'returns true when rates could be retrieved' do
      expect(dec1.import!).to be_truthy
    end

    it 'returns false when there are no rates' do
      expect(future.import!).to be_falsey
    end
  end

  describe '.currencies/.rates/.rate' do
    it 'throws an error when import! has not been called yet' do
      expect { dec1.rates }.to raise_error CentralBankOfKenya::MissingRates
      expect { dec1.currencies }.to raise_error CentralBankOfKenya::MissingRates
      expect { dec1.rate('ISO', 'ISO') }.to raise_error CentralBankOfKenya::MissingRates
    end

    it 'throws an error when there are no rates' do
      future.import!
      expect { future.rates }.to raise_error CentralBankOfKenya::MissingRates
      expect { future.currencies }.to raise_error CentralBankOfKenya::MissingRates
      expect { future.rate('ISO', 'ISO') }.to raise_error CentralBankOfKenya::MissingRates
    end
  end

  describe '.has_rates?' do
    it 'returns true when there are rates' do
      dec1.import!
      expect( dec1 ).to have_rates
    end

    it 'returns false when there are no rates' do
      expect( dec1 ).not_to have_rates
    end
  end

  describe '.rate' do
    it 'returns a specific rate' do
      dec1.import!
      expect(dec1.rate('KES', 'EUR')).to eq 1/112.2322
    end

    it 'returns the inverse rate' do
      dec1.import!
      expect(dec1.rate('EUR', 'KES')).to eq 112.2322
    end

    it 'returns nil when currency is not known' do
      dec1.import!
      expect(dec1.rate('XXX', 'RWF')).to be_nil
      expect(dec1.rate('XXX', 'XXX')).to be_nil
    end
  end

  describe '.currencies' do
    it 'returns an array' do
      dec1.import!
      expect(dec1.currencies).to eq DEC1_RATES.keys
    end
  end

  describe '.rates' do
    it 'returns all rates' do
      dec1.import!
      expect(dec1.rates).to eq DEC1_RATES
    end
  end

  describe '#scrape' do
    it 'returns an empty hash for future dates' do
      result = CentralBankOfKenya::HistoricRates.scrape Date.new(2039, 2, 1)
      expect(result).to eq({})
    end

    it 'produces a hash with exchange rates' do
      result = CentralBankOfKenya::HistoricRates.scrape Date.new(2016, 5, 30)
      expect(result).to eq DEC1_RATES
     end
  end
end
