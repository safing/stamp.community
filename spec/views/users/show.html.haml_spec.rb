RSpec.describe 'users/show.html.haml', type: :view do
  let(:targeted_user) { FactoryBot.create(:user) }
  let(:current_user) { nil }

  def rendered
    assign(:user, targeted_user)
    render
    super
  end

  before do
    without_partial_double_verification do
      allow(view).to receive(:policy).and_return(UserPolicy.new(current_user, targeted_user))
    end
  end

  it 'shows the boosts segment' do
    expect(rendered).to have_content('Boosts')
  end

  context 'user has boosts' do
    let(:targeted_user) { FactoryBot.create(:user, :with_boosts) }

    it 'shows user boosts' do
      targeted_user.boosts.each do |boost|
        expect(rendered).to have_content(boost.reputation)
      end
    end
  end

  context 'user has description' do
    let(:targeted_user) { FactoryBot.create(:user, :with_description) }

    it 'shows user description' do
      expect(rendered).to have_content(targeted_user.description)
    end
  end

  context 'user has no boosts' do
    it 'shows a motivational text' do
      expect(rendered).to have_content('Hey maybe do something more for your reputation!')
    end
  end

  it 'shows the activities segment' do
    expect(rendered).to have_content('Activity')
  end

  context 'user has activities' do
    let(:targeted_user) { FactoryBot.create(:user, :with_activities) }

    it 'shows user activity' do
      targeted_user.activities.each do |activity|
        expect(rendered).to render_template(partial: "activities/_#{activity.key}")
      end
    end
  end

  context 'user has no activities' do
    it 'shows a motivational text' do
      expect(rendered).to have_content('Hey maybe do something more for your activities!')
    end
  end

  context 'user is not logged in' do
    it 'shows the edit button' do
      expect(rendered).not_to have_css('.pen.blue.icon')
    end
  end

  context 'user is logged in' do
    # log in is mocked via setting current_user of UserPolicy
    let(:current_user) { targeted_user }

    it 'shows the edit button' do
      expect(rendered).to have_css('.pen.blue.icon')
    end
  end
end
