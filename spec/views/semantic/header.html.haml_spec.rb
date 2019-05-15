RSpec.describe 'semantic/_header.html.haml', type: :view do
  let(:user) { FactoryBot.create(:user) }

  def rendered
    assign(:user, user)
    render
    super
  end

  context 'user is signed in' do
    include_context 'login user'

    context 'user has notifications' do
      let(:user) { FactoryBot.create(:user, :with_notifications) }

      it 'shows the notification inbox as a purple icon' do
        expect(rendered).to have_css('.inbox.purple.large.icon')
      end
    end

    context 'user has no notifications' do
      it 'shows the notification inbox as a grey icon' do
        expect(rendered).to have_css('.inbox.grey.large.icon')
      end
    end
  end

  context 'no user is signed in' do
  end
end
