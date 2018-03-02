guard 'rspec',
      results_file: File.expand_path('tmp/rspec_guard_result'),
      cmd: 'bundle exec rspec -fd',
      spec_paths: ['spec'] do
  watch('spec/spec_helper.rb') { 'spec' }
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch(%r{(.*)spec/.+_spec\.rb$})
  watch(%r{(.*)app/(.+)\.rb$}) { |m| "#{m[1]}spec/#{m[2]}_spec.rb" }
  watch(%r{(.*)app/api/v[0-9]?/(.+)\.rb$}) { |m| "#{m[1]}spec/api/#{m[2]}_spec.rb" }
  watch(%r{(.*)lib/(.+)\.rb$}) { |m| "#{m[1]}spec/lib/#{m[2]}_spec.rb" }
end
