RSpec.shared_examples 'PublicActivity::Owner' do |options|
  let(:instance) { FactoryBot.create(options[:factory]) }
  let(:class_name_env) { instance.class_name_env }

  describe 'relations' do
    it do
      is_expected.to have_many(:activities_as_owner).class_name('PublicActivity::Activity')
    end
  end
end
