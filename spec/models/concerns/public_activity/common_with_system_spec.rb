RSpec.describe PublicActivity, type: :model do
  describe '::CommonWithSystem' do
    let(:stamp) { FactoryBot.create(:label_stamp) }

    describe '#create_activity' do
      subject { stamp.create_activity(action, owner: user) }
      let(:action) { :update }

      context 'owner is set' do
        let(:user) { FactoryBot.create(:user) }

        it 'creates an Activity with {action: stamp_label.update, owner: user}' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp_label.update')
            expect(activity.owner_type).to eq('User')
            expect(activity.owner_id).to eq(user.id)
          end
        end
      end

      context 'owner is not set' do
        let(:user) { nil }

        it 'creates an Activity with {action: stamp_label.update, owner: nil' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp_label.update')
            expect(activity.owner_type).to be_nil
            expect(activity.owner_id).to be_nil
          end
        end
      end
    end

    describe '#create_system_activity' do
      subject { stamp.create_system_activity(action, owner: user) }
      let(:action) { :update }

      context 'owner is set' do
        let(:user) { FactoryBot.create(:user) }

        it 'creates Activity with {key: stamp_label.update, owner_type: System, owner_id: -1}' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp_label.update')
            expect(activity.owner_type).to eq('System')
            expect(activity.owner_id).to eq(-1)
          end
        end
      end

      context 'owner is not set' do
        let(:user) { nil }

        it 'creates Activity with {key: stamp_label.update, owner_type: System, owner_id: -1}' do
          PublicActivity.with_tracking do
            expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(1)

            activity = PublicActivity::Activity.first
            expect(activity.key).to eq('stamp_label.update')
            expect(activity.owner_type).to eq('System')
            expect(activity.owner_id).to eq(-1)
          end
        end
      end
    end

    describe 'creating multiple activities' do
      describe 'first #create_system_activity, then #create_activity' do
        subject do
          stamp.create_system_activity(action, owner: user)
          stamp.create_activity(action, owner: user)
        end

        let(:action) { :update }

        context 'owner is set' do
          let(:user) { FactoryBot.create(:user) }

          it 'creates two activities, one with user as owner, the second with system as owner' do
            PublicActivity.with_tracking do
              expect { subject }.to change { PublicActivity::Activity.count }.from(0).to(2)

              system_activity = PublicActivity::Activity.first
              expect(system_activity.key).to eq('stamp_label.update')
              expect(system_activity.owner_type).to eq('System')
              expect(system_activity.owner_id).to eq(-1)

              user_activity = PublicActivity::Activity.last
              expect(user_activity.key).to eq('stamp_label.update')
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
              expect(system_activity.key).to eq('stamp_label.update')
              expect(system_activity.owner_type).to eq('System')
              expect(system_activity.owner_id).to eq(-1)

              user_activity = PublicActivity::Activity.last
              expect(user_activity.key).to eq('stamp_label.update')
              expect(user_activity.owner_type).to be_nil
              expect(user_activity.owner_id).to be_nil
            end
          end
        end
      end
    end
  end
end
