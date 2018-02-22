require 'spec_helper'

RSpec.describe ENVProxy do
  describe '.required' do
    subject { ENVProxy.required('SOME_KEY') }

    context 'ENV is set' do
      before { ENV['SOME_KEY'] = 'ENV VALUE' }

      it { is_expected.to eq('ENV VALUE') }
    end

    context 'ENV is not set' do
      before { ENV['SOME_KEY'] = nil }

      it 'raises an exception' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end

  describe '.optional' do
    subject { ENVProxy.optional('SOME_KEY') }

    context 'ENV is set' do
      before { ENV['SOME_KEY'] = 'ENV VALUE' }

      it { is_expected.to eq('ENV VALUE') }
    end

    context 'ENV is not set' do
      before { ENV['SOME_KEY'] = nil }

      it { is_expected.to be nil }
    end
  end

  describe '.required_array' do
    subject { ENVProxy.required_array('SOME_ARRAY') }

    context 'ENV is set' do
      before { ENV['SOME_ARRAY'] = 'a,b,c,d,e' }

      it { is_expected.to match_array(%w[a b c d e]) }
    end

    context 'ENV is not set' do
      before { ENV['SOME_ARRAY'] = nil }

      it 'raises an exception' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end

  describe '.optional_array' do
    subject { ENVProxy.optional_array('SOME_ARRAY') }

    context 'ENV is set' do
      before { ENV['SOME_ARRAY'] = 'a,b,c,d,e' }

      it { is_expected.to match_array(%w[a b c d e]) }
    end

    context 'ENV is not set' do
      before { ENV['SOME_ARRAY'] = nil }

      it { is_expected.to eq [] }
    end
  end

  describe '.required_integer' do
    subject { ENVProxy.required_integer('SOME_INTEGER') }

    context 'ENV is set' do
      context 'ENV is an integer' do
        before { ENV['SOME_INTEGER'] = '87' }

        it { is_expected.to eq(87) }
      end

      context 'ENV is a string' do
        before { ENV['SOME_INTEGER'] = 'abc' }

        it { is_expected.to eq(0) }
      end
    end

    context 'ENV is not set' do
      before { ENV['SOME_INTEGER'] = nil }

      it 'raises an exception' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end

  describe '.optional_integer' do
    subject { ENVProxy.optional_integer('SOME_INTEGER') }

    context 'ENV is set' do
      context 'ENV is an integer' do
        before { ENV['SOME_INTEGER'] = '87' }

        it { is_expected.to eq(87) }
      end

      context 'ENV is a string' do
        before { ENV['SOME_INTEGER'] = 'abc' }

        it { is_expected.to eq(0) }
      end
    end

    context 'ENV is not set' do
      before { ENV['SOME_INTEGER'] = nil }

      it { is_expected.to eq(0) }
    end
  end
end
