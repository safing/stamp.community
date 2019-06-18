<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  it 'has a valid factory' do
    expect(FactoryBot.create(:<%= file_name %>)).to be_valid
  end
  
  describe 'database' do
  end

  describe 'relations' do
  end

  describe 'validations' do
  end
end
<% end -%>
