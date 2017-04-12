require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'Bleemeo agent' do
  it 'has a running service of Bleemeo agent' do
    expect(service('bleemeo-agent')).to be_running
  end
end
