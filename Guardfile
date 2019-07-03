guard :rspec,
      results_file: File.expand_path('tmp/rspec_guard_result'),
      cmd: 'bundle exec rspec -fd --exclude-pattern "**/features/**/*_spec.rb"',
      spec_paths: ['spec'] do
  watch('spec/spec_helper.rb') { 'spec' }

  # match controllers with their request specs
  watch('app/controllers/application_controller.rb') { 'spec/requests' }
  watch(%r{app/controllers/(.+)s_controller\.rb$}) { |m| "spec/requests/#{m[1]}_requests_spec.rb" }
  watch(%r{app/controllers/static_controller\.rb$}) { 'spec/requests/static_requests_spec.rb' }
  watch(%r{(.*)spec/((?!support).+)_spec\.rb$})
  watch(%r{(.*)app/(.+)\.rb$}) { |m| "#{m[1]}spec/#{m[2]}_spec.rb" }
  watch(%r{(.*)app/(.+)\.haml$}) { |m| "#{m[1]}spec/#{m[2]}.haml_spec.rb" }
  watch(%r{(.*)app/api/v[0-9]?/(.+)\.rb$}) { |m| "#{m[1]}spec/api/#{m[2]}_spec.rb" }
  watch(%r{(.*)lib/(.+)\.rb$}) { |m| "#{m[1]}spec/lib/#{m[2]}_spec.rb" }
end
