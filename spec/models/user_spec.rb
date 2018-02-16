require 'spec_helper'

RSpec.describe User do
  describe '#voting_power' do
    subject { user.voting_power }
    let(:user) { FactoryBot.create(:user, reputation: reputation) }

    context 'user has negative REP' do
      let(:reputation) { -100 }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'user has 0 REP' do
      let(:reputation) { 0 }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'user has positive REP' do
      context 'user has between 1..9 REP' do
        let(:reputation) { Faker::Number.between(1, 9) }

        it 'returns 1' do
          expect(subject).to eq(1)
        end
      end

      context 'user has between 10..99 REP' do
        let(:reputation) { Faker::Number.between(10, 99) }

        it 'returns 2' do
          expect(subject).to eq(2)
        end
      end

      context 'user has between 100..999 REP' do
        let(:reputation) { Faker::Number.between(100, 999) }

        it 'returns 3' do
          expect(subject).to eq(3)
        end
      end

      context 'user has between 1000..9999 REP' do
        let(:reputation) { Faker::Number.between(1000, 9999) }

        it 'returns 4' do
          expect(subject).to eq(4)
        end
      end
    end
	end
end
