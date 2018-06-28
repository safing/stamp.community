shared_examples_for 'status code' do |status|
  description = case status
                when 404 then ' (:not_found)'
                when 401 then ' (:unauthorized)'
                end

  it "returns status code #{status}#{description}" do
    subject
    expect(response).to have_http_status(status)
  end
end
