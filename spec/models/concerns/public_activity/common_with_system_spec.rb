RSpec.describe PublicActivity, type: :model do
  describe '::CommonWithSystem' do
    let(:stamp) { FactoryBot.create(:label_stamp) }
    # manually set key since ::Common#prepare_key does not allow option to pick base_class
    # github.com/chaps-io/public_activity/blob/1-6-stable/lib/public_activity/common.rb#L329
    # in Votable::State this is also set manually
    let(:key) { stamp.key_for(action: action) }

    describe '#create_activity' do
      subject { stamp.create_activity(action, owner: user, key: key) }
      let(:action) { :create }

      context 'owner is set' do
        let(:user) { FactoryBot.create(:user) }

        it 'creates an Activity with {action: stamp.create, owner: user}' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp.create')
            expect(activity.owner_type).to eq('User')
            expect(activity.owner_id).to  eq(user.id)
          end
        end
      end

      context 'owner is not set' do
        let(:user) { nil }

        it 'creates an Activity with {action: stamp.create, owner: nil' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp.create')
            expect(activity.owner_type).to be_nil
            expect(activity.owner_id).to be_nil
          end
        end
      end
    end

    describe '#create_system_activity' do
      subject { stamp.create_system_activity(action, owner: user, key: key) }
      let(:action) { :accept }

      context 'owner is set' do
        let(:user) { FactoryBot.create(:user) }

        it 'creates Activity with {key: stamp.accept, owner_type: System, owner_id: -1}' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp.accept')
            expect(activity.owner_type).to eq('System')
            expect(activity.owner_id).to eq(-1)
          end
        end
      end

      context 'owner is not set' do
        let(:user) { nil }

        it 'creates Activity with {key: stamp.accept, owner_type: System, owner_id: -1}' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp.accept')
            expect(activity.owner_type).to eq('System')
            expect(activity.owner_id).to eq(-1)
          end
        end
      end
    end

    describe 'creating multiple activities' do
      describe 'first #create_system_activity, then #create_activity' do
        subject do
          stamp.create_system_activity(action, owner: user, key: key)
          stamp.create_activity(action, owner: user, key: key)
        end

        let(:action) { :accept }

        context 'owner is set' do
          let(:user) { FactoryBot.create(:user) }

          it 'creates two activities, one with user as owner, the second with system as owner' do
            PublicActivity.with_tracking do
              expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(2)

              system_activity = PublicActivity::Activity.first
              expect(system_activity.key).to eq('stamp.accept')
              expect(system_activity.owner_type).to eq('System')
              expect(system_activity.owner_id).to eq(-1)

              user_activity = PublicActivity::Activity.last
              expect(user_activity.key).to eq('stamp.accept')
              expect(user_activity.owner_type).to eq('User')
              expect(user_activity.owner_id).to eq(user.id)
            end
          end
        end

        context 'owner is not set' do
          let(:user) { nil }

          it 'creates two activities, one with owner nil, the second with system as owner' do
            PublicActivity.with_tracking do
              expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(2)

              system_activity = PublicActivity::Activity.first
              expect(system_activity.key).to eq('stamp.accept')
              expect(system_activity.owner_type).to eq('System')
              expect(system_activity.owner_id).to eq(-1)

              user_activity = PublicActivity::Activity.last
              expect(user_activity.key).to eq('stamp.accept')
              expect(user_activity.owner_type).to be_nil
              expect(user_activity.owner_id).to be_nil
            end
          end
        end
      end
    end
  end
end
