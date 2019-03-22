shared_context 'with activity tracking' do
  around do |test|
    PublicActivity.with_tracking do
      test.run
    end
  end
end
