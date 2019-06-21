module Rails
  module Generators
    class PolicyGenerator < NamedBase
      source_root File.expand_path('templates', __dir__)

      # this generator is invoked when scaffolding instead of Helper
      # BUT it is invoked in a pluralized state:
      #   => as a result, a plural Policy is created, iE "UsersPolicy"
      # https://github.com/rails/rails/blob/c631e8d011a7cf3e7ade4e9e8db56d2b89bd530c/railties/lib/rails/generators/rails/scaffold_controller/scaffold_controller_generator.rb#L31

      # we're circumventing this 'bug'
      # (which results from our hackish way of invoking the policy in scaffold)
      # by singularizing the first argument [name]
      def initialize(args, *options)
        args[0] = args[0].singularize
        super
      end

      def create_policy_file
        template 'policy.rb', File.join('app/policies', class_path, "#{file_name}_policy.rb")
      end

      hook_for :test_framework
    end
  end
end
