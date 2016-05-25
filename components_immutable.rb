class LeafComponent
  attr_reader :storage_capacity, :occupied_space

  def initialize(storage_capacity, stored_chars = [])
    @storage_capacity = storage_capacity
    @stored_chars = stored_chars
  end

  def free_space
    @storage_capacity - @stored_chars.size
  end

  def occupied_space
    @stored_chars.size
  end

  def write(chars)
    #TODO: Add guard clause or shift to better model ???
    LeafComponent.new(storage_capacity, @stored_chars + chars)
  end
end

class Component
  [:occupied_space, :storage_capacity, :free_space].each do |message|
    define_method(message) do
      @sub_components.inject(0) { |acc, component| acc + component.send(message) }
    end
  end

  def initialize(sub_components)
    @sub_components = sub_components
  end

  def write(chars)
    written_sub_components = @sub_components.map do |component|
      component.write(chars.shift(component.free_space))
    end
    Component.new(written_sub_components)
  end
end

t1, t2 = LeafComponent.new(1), LeafComponent.new(3)
p t1
p t2
c1 = Component.new([t1, t2])
p c1
p c1.occupied_space
p c1.storage_capacity

c2 = c1.write(['a','b','c'])
c3 = c2.write(['d'])
p "old components -> " + c1.inspect.to_s
p "new components -> " + c2.inspect.to_s
p "newer components -> " + c3.inspect.to_s








