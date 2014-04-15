describe 'RansackWrap' do
  it 'can be required without errors' do
    output = `bundle exec ruby -e "require 'ransack_wrap'" 2>&1`
    output.should be_empty
  end
end