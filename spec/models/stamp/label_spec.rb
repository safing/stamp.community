RSpec.describe Stamp::Label, type: :model do
  it_behaves_like 'a STI child of Stamp', factory: :label_stamp

  it 'has a valid factory' do
    expect(FactoryBot.create(:label_stamp)).to be_valid
  end

  describe 'relations' do
    # shoulda-matchers does not support jsonb relations
    xit { is_expected.to belong_to(:label).class_name('::Label') }
  end

  describe 'validations' do
    describe 'shoulda matchers' do
      # shoulda matchers sets the label_id / percentage to nil,
      # #complies_to_label_config uses label_id / percentage
      # => throws an error
      # hence, stub the method to make the shoulda matchers work again
      before { allow(subject).to receive(:complies_to_label_config).and_return(true) }

      it { is_expected.to validate_inclusion_of(:stampable_type).in_array(['Domain']) }
      it { is_expected.to validate_presence_of(:label_id) }
      it { is_expected.to validate_presence_of(:percentage) }
    end

    describe '#complies_to_label_config' do
      subject { label_stamp.complies_to_label_config }

      let(:label) { FactoryBot.create(:label, steps: steps, binary: binary) }
      let(:label_stamp) { FactoryBot.build(:label_stamp, label: label, percentage: percentage) }

      let(:steps) { 5 }
      let(:binary) { false }
      let(:percentage) { 5 }

      let(:binary_error) { 'Percentage must equal 0 or 100, since the referenced label is binary' }
      let(:steps_error) do
        "Percentage must be set to steps of #{steps}, as defined by the referenced label"
      end

      it 'gets called once by #valid?' do
        expect(label_stamp).to receive(:complies_to_label_config).and_call_original
        label_stamp.valid?
      end

      context 'assigned labels #binary = true' do
        let(:binary) { true }

        context '#percentage is 100' do
          let(:percentage) { 100 }

          it 'does not add an error to the instance' do
            expect { subject }.not_to change { label_stamp.errors.count }.from(0)
          end
        end

        context '#percentage is 50' do
          let(:percentage) { 50 }

          context 'assigned labels #steps = 10' do
            let(:steps) { 10 }

            it 'ignores the steps and adds a binary_error to the instance' do
              expect { subject }.to change { label_stamp.errors.count }.from(0).to(1)
              expect(label_stamp.errors.full_messages.first).to eq(binary_error)
            end
          end

          context 'assigned labels #steps is not set' do
            it 'adds a binary_error to the instance' do
              expect { subject }.to change { label_stamp.errors.count }.from(0).to(1)
              expect(label_stamp.errors.full_messages.first).to eq(binary_error)
            end
          end
        end

        context '#percentage is 0' do
          let(:percentage) { 0 }

          it 'does not add an error to the instance' do
            expect { subject }.not_to change { label_stamp.errors.count }.from(0)
          end
        end
      end

      context 'assigned labels #binary = false' do
        let(:binary) { false }

        context 'assigned labels #steps = 10' do
          let(:steps) { 10 }

          context '#percentage is 0' do
            let(:percentage) { 0 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end

          context '#percentage is 5' do
            let(:percentage) { 5 }

            it 'adds a steps_error to the instance' do
              expect { subject }.to change { label_stamp.errors.count }.from(0).to(1)
              expect(label_stamp.errors.full_messages.first).to eq(steps_error)
            end
          end

          context '#percentage is 10' do
            let(:percentage) { 10 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end

          context '#percentage is 95' do
            let(:percentage) { 95 }

            it 'adds a steps_error to the instance' do
              expect { subject }.to change { label_stamp.errors.count }.from(0).to(1)
              expect(label_stamp.errors.full_messages.first).to eq(steps_error)
            end
          end
        end

        context 'assigned labels #steps = 5' do
          let(:steps) { 5 }

          context '#percentage is 0' do
            let(:percentage) { 0 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end

          context '#percentage is 7' do
            let(:percentage) { 7 }

            it 'adds a steps_error to the instance' do
              expect { subject }.to change { label_stamp.errors.count }.from(0).to(1)
              expect(label_stamp.errors.full_messages.first).to eq(steps_error)
            end
          end

          context '#percentage is 10' do
            let(:percentage) { 10 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end

          context '#percentage is 93' do
            let(:percentage) { 93 }

            it 'adds a steps_error to the instance' do
              expect { subject }.to change { label_stamp.errors.count }.from(0).to(1)
              expect(label_stamp.errors.full_messages.first).to eq(steps_error)
            end
          end
        end

        context 'assigned labels #steps = 1' do
          let(:steps) { 1 }

          context '#percentage is 0' do
            let(:percentage) { 0 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end

          context '#percentage is 7' do
            let(:percentage) { 7 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end

          context '#percentage is 10' do
            let(:percentage) { 10 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end

          context '#percentage is 93' do
            let(:percentage) { 93 }

            it 'does not add an error to the instance' do
              expect { subject }.not_to change { label_stamp.errors.count }.from(0)
            end
          end
        end
      end
    end

    describe '#initial_stamp_cannot_be_0' do
      subject { label_stamp.valid? }
      let!(:label) { FactoryBot.create(:label) }
      let!(:domain) { FactoryBot.create(:domain) }
      let(:label_stamp) do
        FactoryBot.build(
          :label_stamp,
          percentage: percentage,
          label_id: label.id,
          stampable: domain
        )
      end

      context 'percentage is 0' do
        let(:percentage) { 0 }

        context 'stamp has siblings' do
          before do
            FactoryBot.create(:label_stamp, state: state, label_id: label.id, stampable: domain)
          end

          context "siblings' state is accepted" do
            let(:state) { :accepted }

            it 'returns true' do
              expect(subject).to be true
            end
          end

          context "siblings' state is not accepted" do
            let(:state) { :in_progress }

            it 'returns false' do
              expect(subject).to be false
              expect(label_stamp.errors.full_messages.first).to(
                include('Percentage can only be set to 0 if an accepted sibling stamp is > 0')
              )
            end
          end
        end

        context 'stamp has no siblings' do
          it 'returns false' do
            expect(subject).to be false
            expect(label_stamp.errors.full_messages.first).to(
              include('Percentage can only be set to 0 if an accepted sibling stamp is > 0')
            )
          end
        end
      end

      context 'percentage is not 0' do
        let(:percentage) { 100 }

        it 'returns true' do
          expect(subject).to be true
        end
      end
    end
  end

  describe '#siblings' do
    subject { label_stamp.siblings }
    let(:label_stamp) { FactoryBot.create(:label_stamp, label_id: label.id) }
    let(:label) { FactoryBot.create(:label) }

    context 'stamp has no siblings' do
      context 'stamp has peers' do
        before { label_stamp.domain.stamps << FactoryBot.create_list(:label_stamp, 2) }

        it 'returns an empty array' do
          expect(subject).to eq([])
        end
      end

      context 'stamp has no peers' do
        it 'returns an empty array' do
          expect(subject).to eq([])
        end
      end
    end

    context 'stamp has sibling stamps' do
      before do
        label_stamp.domain.stamps << FactoryBot.create_list(:label_stamp, 2, label_id: label.id)
      end

      it 'returns all siblings' do
        expect(subject.count).to eq(2)
      end

      it 'does not return itself' do
        expect(subject.pluck(:id)).not_to include(label_stamp.id)
      end
    end
  end
end
