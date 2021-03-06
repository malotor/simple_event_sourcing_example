RSpec.describe 'An employee' do
  before(:each) do
    @fred = Employee.create('8aa14c4f-5244-43f7-a2ba-f83c1327d669', 'Fred Flintstone', 'Crane Operator', 30_000.0)

    @subscribers = []
    @subscribers << spy(:spy_subscriber)
    @subscribers.each do |s|
      SimpleEventSourcing::Events::EventDispatcher.add_subscriber(s)
      allow(s).to receive(:handle)
      allow(s).to receive(:is_subscribet_to?).and_return(true)
    end
  end

  after(:each) do
    @subscribers.each { |s| SimpleEventSourcing::Events::EventDispatcher.delete_subscriber(s) }
  end

  it 'has an id' do
    expect(@fred.id).to eq '8aa14c4f-5244-43f7-a2ba-f83c1327d669'
  end

  it 'has a name and title' do
    expect(@fred.name).to eq 'Fred Flintstone'
    expect(@fred.title).to eq 'Crane Operator'
  end

  it 'has initial salary when is hired' do
    expect(@fred.salary).to eq 30_000
  end

  it 'could have a raise' do
    @fred.promote 35_000
    expect(@fred.salary).to eq 35_000
  end
end
