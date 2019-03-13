RSpec.describe 'users/show.html.haml', type: :view do
  let(:user) { FactoryBot.create(:user) }

  def rendered
    assign(:user, user)
    render
    super
  end

  it 'shows the boosts segment' do
    expect(rendered).to have_content('Boosts')
  end

  context 'user has boosts' do
    let(:user) { FactoryBot.create(:user, :with_boosts) }

    it 'shows user boosts' do
      user.boosts.each do |boost|
        expect(rendered).to have_content(boost.reputation)
      end
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
    let(:user) { FactoryBot.create(:user, :with_activities) }

    it 'shows user activity' do
      user.activities.each do |activity|
        expect(rendered).to render_template(partial: "activities/_#{activity.key}")
      end
    end
  end

  context 'user has no activities' do
    it 'shows a motivational text' do
      expect(rendered).to have_content('Hey maybe do something more for your activities!')
    end
  end
end
