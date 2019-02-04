<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  it 'has a valid factory' do
    expect(FactoryBot.create(:<%= class_name.parameterize %>)).to be_valid
  end

  describe 'relations' do
  end

  describe 'validations' do
  end

  describe 'database' do
  end
end
<% end -%>
