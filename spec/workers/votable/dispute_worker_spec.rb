RSpec.describe Votable::DisputeWorker, type: :worker do
  describe '#perform' do
    subject { dispute_worker.perform(votable_type: votable_type, votable_id: votable_id) }
    let(:dispute_worker) { Votable::DisputeWorker.new }

    context 'votable exists' do
      let(:votable) { FactoryBot.create(:stamp, state: state) }
      let(:votable_type) { votable.class.to_s }
      let(:votable_id) { votable.id }

      context 'state is not :in_progress' do
        let(:state) { :denied }

        it 'raises Votable::NotInProgressError' do
          expect { subject }.to raise_error(Votable::NotInProgressError)
        end
      end

      context 'state is :in_progress' do
        let(:state) { 'in_progress' }

        it 'calls votable#dispute!' do
          expect_any_instance_of(Stamp).to receive(:dispute!)
          subject
        end

        it 'denies the votable' do
          expect { subject }.to change { votable.reload.state }.from(state).to('disputed')
        end
      end
    end
  end
end
