RSpec.describe Votable::ConcludeWorker, type: :worker do
  describe '#perform' do
    subject { conclude_worker.perform(votable_type: votable_type, votable_id: votable_id) }
    let(:conclude_worker) { Votable::ConcludeWorker.new }

    context 'votable does not exist' do
      let(:votable_type) { 'Stamp' }
      let(:votable_id) { 87 }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'votable exists' do
      let(:votable) { FactoryBot.create(:stamp, state: state) }
      let(:votable_type) { votable.class.to_s }
      let(:votable_id) { votable.id }

      context 'state is not :in_progress' do
        let(:state) { :accepted }

        it 'raises Votable::NotInProgressError' do
          expect { subject }.to raise_error(Votable::NotInProgressError)
        end
      end

      context 'state is :in_progress' do
        let(:state) { :in_progress }

        it 'calls votable#conclude!' do
          expect_any_instance_of(Stamp).to receive(:conclude!)
          subject
        end
      end
    end
  end
end
