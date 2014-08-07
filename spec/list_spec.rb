require 'spec_helper'

describe List do
  it 'is initialized with a name' do
    list = List.new('Epicodus stuff')
    list.should be_an_instance_of List
  end

  it 'tells you its name' do
    list = List.new('Epicodus stuff')
    list.name.should eq 'Epicodus stuff'
  end

  it 'is the same list if it has the same name' do
    list1 = List.new('Epicodus stuff')
    list2 = List.new('Epicodus stuff')
    list1.should eq list2
  end

  it 'starts off with no lists' do
    List.all.should eq []
  end

  it 'lets you save lists to the database' do
    list = List.new('Epicodus stuff')
    list.save
    List.all.should eq [list]
  end

  it 'sets its ID when you save it' do
    list = List.new('Epicodus stuff')
    list.save
    list.id.should be_an_instance_of Fixnum
  end

  it 'removes a list from the database' do
    list = List.new('Epicodus stuff')
    list.save
    List.remove_list(list.id)
    List.all.should eq []
  end

  it 'removes all tasks associated with the list when deleted' do
    list = List.new('Epicodus stuff')
    list.save
    task1 = Task.new('learn SQL', list.id, 'n', '2014-08-08')
    task1.save
    List.remove_list(list.id)
    List.all.should eq []
    Task.all.should eq []
  end
end

