class LeafComponent
  attr_reader :storage_capacity, :occupied_space
  def initialize(storage_capacity)
    @storage_capacity = storage_capacity
    @stored_chars = []
  end

  def free_space
    @storage_capacity - @stored_chars.size
  end

  def occupied_space
    @stored_chars.size
  end

  def write(chars)
    @stored_chars << chars
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
    @sub_components.each do |component|
      component.write(chars.shift(component.free_space))
    end
  end
end

t1, t2 = LeafComponent.new(1), LeafComponent.new(3)
p t1
p t2
c1 = Component.new([t1, t2])
p c1
p c1.occupied_space
p c1.storage_capacity

c1.write(['a','b','c','d'])
p c1