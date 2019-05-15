RSpec.describe PublicActivity::Activity, type: :model do
  describe 'relations' do
    it { is_expected.to have_one(:boost).with_foreign_key(:cause_id) }
    it { is_expected.to have_many(:boosts).with_foreign_key(:trigger_id) }
  end

  describe 'database' do
    it { is_expected.to have_db_index(%i[trackable_id trackable_type]) }
    it { is_expected.to have_db_index(%i[owner_id owner_type]) }
    it { is_expected.to have_db_index(%i[recipient_id recipient_type]) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_inclusion_of(:key).in_array(Activity::KEYS) }
  end

  describe '#config_key' do
    subject { activity.config_key }
    let(:activity) { FactoryBot.create(:signup_activity) }

    it 'replaces the key´s . with _' do
      expect(subject).to eq(:user_signup)
    end

    it 'returns a symbol' do
      expect(subject.class).to eq(Symbol)
    end
  end

  describe '#cache_key_set?(cache_key)' do
    subject { activity.cache_key_set?(cache_key) }
    let(:activity) { FactoryBot.create(:app_activity) }

    context 'cache_key is configured' do
      let(:cache_key) { :app_name }

      it 'returns true' do
        expect(subject).to be true
      end
    end

    context 'cache_key is not configured' do
      let(:cache_key) { :unset_key }

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end

  describe '#cache(cache_key)' do
    subject { activity.cache(cache_key) }

    let(:activity) { FactoryBot.create(:signup_activity, parameters: parameters, trackable: user) }
    let(:user) { FactoryBot.create(:user) }
    let(:parameters) { {} }

    context 'cache_key is set' do
      let(:cache_key) { :user_username }

      context 'cache is already set' do
        let(:parameters) { { user_username: user.username } }

        it 'returns the cached value' do
          expect(subject).to eq(user.username)
        end
      end

      context 'cache is not set yet' do
        it 'sets the cache' do
          expect { subject }.to change { activity.parameters }.from({}).to(
            'user_username' => user.username
          )
        end

        it 'recalls #cache(cache_key) to return the value' do
          expect(activity).to receive(:cache).twice.with(cache_key).and_call_original
          subject
        end
      end
    end

    context 'cache_key is not set' do
      let(:cache_key) { :unset_key }

      it 'returns nil' do
        expect(subject).to eq nil
      end
    end
  end

  describe '#fetch_value(retrievers)' do
    subject { activity.fetch_value(retrievers) }

    describe 'CACHE_CONFIG' do
      Activity::CACHE_CONFIG.each do |config_key, config_hash|
        model_type = config_key.to_s.split('_').first
        factory_key = "#{model_type}_activity".to_sym
        activity_key = config_key.to_s.sub('_', '.')

        context "for '#{activity_key}' activity" do
          config_hash.each do |cache_key, retrievers|
            let(:activity) { FactoryBot.create(factory_key, key: activity_key) }
            let(:retrievers) { retrievers }

            describe "cache_key: #{cache_key}" do
              describe "#fetch_value('#{retrievers}')" do
                it 'does not raise an error' do
                  expect { subject }.not_to raise_error
                end

                it 'does not return nil' do
                  expect(subject).not_to eq(nil)
                end
              end
            end
          end
        end
      end
    end
  end

  describe 'view partials' do
    Activity::KEYS.each do |key|
      it "#{key}.html.haml partial exists" do
        expect(File).to exist("app/views/activities/_#{key}.html.haml")
      end
    end
  end
end
