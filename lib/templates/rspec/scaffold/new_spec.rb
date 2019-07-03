RSpec.describe '<%= ns_table_name %>/new.html.haml', <%= type_metatag(:view) %> do
  let(:<%= singular_name %>) { FactoryBot.build(:<%= singular_name %>) }

  def rendered
    assign(:<%= singular_name %>, <%= singular_name %>)
    render
    super
  end
end
