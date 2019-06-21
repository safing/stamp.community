<% module_namespacing do -%>
RSpec.feature '<%= singular_table_name %>', <%= type_metatag(:request) %> do
  # the scaffolded policy defaults everything to false
  #  => as a result, the guest specs will fail
  #  => BUT the 'user is authorized' specs will succeed
  #     because the Policy#authorize call is mocked
  #     it's simulating any scenario where the user is authorized
  # the real authorization specs should and are placed in <%= file_name %>_policy_spec.rb
  #  => this only tests that routes are set up and respond accordingly
  describe 'authentication & authourization' do
    # :authorize calls :public_send on the fitting Policy
    # this is easier to stub than :authorize, which would not raise an error
    # https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L221
    shared_context 'user is authorized' do
      before do
        allow_any_instance_of(<%= class_name %>Policy).to(receive(:public_send).and_return(true))
      end
    end

    shared_context 'user is unauthorized' do
      before do
        allow_any_instance_of(<%= class_name %>Policy).to(receive(:public_send).and_return(false))
      end
    end

    describe '#show' do
      subject(:request) { get <%= singular_table_name %>_path(<%= singular_route_name %>) }
      let(:<%= singular_table_name %>) { FactoryBot.create(:<%= singular_table_name %>) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'login user'

          include_context 'user is authorized'
          include_examples 'status code', 200
        end
      end
    end

    describe '#new' do
      subject(:request) { get new_<%= singular_route_name %>_url }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
      end
    end

    describe '#edit' do
      subject(:request) { get edit_<%= singular_route_name %>_path(id: <%= singular_table_name %>.id) }
      let(:<%= singular_table_name %>) { FactoryBot.create(:<%= singular_table_name %>) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 200
        end
      end
    end

    describe '#create' do
      subject(:request) { post <%= plural_route_name %>_url, params: { <%= singular_table_name %>: <%= singular_table_name %>_attributes } }
      let(:<%= singular_table_name %>_attributes) do
        FactoryBot.attributes_for(:<%= singular_table_name %>)
      end

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 302
        end
      end
    end

    describe '#update' do
      subject(:request) { patch <%= singular_route_name %>_path(<%= singular_table_name %>), params: { <%= singular_table_name %>: <%= singular_table_name %>_attributes } }

      let(:<%= singular_table_name %>) { FactoryBot.create(:<%= singular_table_name %>) }
      let(:<%= singular_table_name %>_attributes) { FactoryBot.attributes_for(:<%= singular_table_name %>) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 302
        end
      end
    end

    describe '#destroy' do
      subject(:request) { delete <%= singular_route_name %>_path(<%= singular_table_name %>) }
      let(:<%= singular_table_name %>) { FactoryBot.create(:<%= singular_table_name %>) }

      context 'user is unauthenticated (guest)' do
        include_examples 'status code', 401
      end

      context 'user is authenticated' do
        include_context 'login user'

        context 'user is unauthorized' do
          include_context 'user is unauthorized'
          include_examples 'status code', 401
        end

        context 'user is authorized' do
          include_context 'user is authorized'
          include_examples 'status code', 302
        end
      end
    end
  end
end
<% end -%>
