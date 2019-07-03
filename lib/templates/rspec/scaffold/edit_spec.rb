RSpec.describe '<%= ns_table_name %>/edit.html.haml', <%= type_metatag(:view) %> do
  let(:<%= singular_name %>) { FactoryBot.create(:<%= singular_name %>) }

  def rendered
    assign(:<%= singular_name %>, <%= singular_name %>)
    render
    super
  end
end
