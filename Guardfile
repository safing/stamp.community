guard 'rspec',
    results_file: File.expand_path('tmp/rspec_guard_result'),
    cmd: 'bundle exec rspec -fd',
    spec_paths: ['spec', 'engines/*/spec'] do
  watch('spec/rails_helper.rb') { 'spec' }
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch(%r{(.*)spec/.+_spec\.rb$})
  watch(%r{(.*)app/(.+)\.rb$}) { |m| "#{m[1]}spec/#{m[2]}_spec.rb" }
  watch(%r{(.*)lib/(.+)\.rb$}) { |m| "#{m[1]}spec/lib/#{m[2]}_spec.rb" }
end
