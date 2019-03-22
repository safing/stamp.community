RSpec.shared_examples_for 'status code' do |status|
  description = case status
                when 404 then ' (:not_found)'
                when 401 then ' (:unauthorized)'
                end

  it "returns status code #{status}#{description}" do
    subject
    expect(response).to have_http_status(status)
  end
end

RSpec.shared_context 'login user' do
  before do
    sign_in(defined?(user) ? user : FactoryBot.create(:user))
  end
end

RSpec.shared_context 'login moderator' do
  before { sign_in(FactoryBot.create(:moderator)) }
end

RSpec.shared_context 'login admin' do
  before { sign_in(FactoryBot.create(:admin)) }
end
