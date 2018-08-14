RSpec.describe Votable::AcceptWorker, type: :worker do
  describe '#perform' do
    subject { accept_worker.perform(votable_type: votable_type, votable_id: votable_id) }
    let(:accept_worker) { Votable::AcceptWorker.new }

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
        let(:state) { 'in_progress' }

        it 'calls votable#accept!' do
          expect_any_instance_of(Stamp).to receive(:accept!)
          subject
        end

        it 'accepts the votable' do
          expect { subject }.to change { votable.reload.state }.from(state).to('accepted')
        end
      end
    end
  end
end
