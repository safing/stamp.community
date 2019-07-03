RSpec.describe '<%= ns_table_name %>/index.html.haml', <%= type_metatag(:view) %> do
  let(:<%= plural_name %>) { FactoryBot.create_list(:<%= singular_name %>, 2) }

  def rendered
    assign(:<%= plural_name %>, <%= plural_name %>)
    render
    super
  end
end
