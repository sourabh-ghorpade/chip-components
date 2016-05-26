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
    @stored_chars += chars
  end
end

class BestFitStrategy
  def self.select(components, number_of_items)
    selected_component = nil
    best_fit_difference = 1000000
    components.each do |component|
      fit_difference = component.free_space - number_of_items
      selected_component = component if(fit_difference >= 0 && fit_difference < best_fit_difference)
    end
    return selected_component, selected_component.free_space
  end
end

class FirstFitStrategy
  def self.select(components, number_of_items) 
    selected_component = components.find { |component| component.free_space != 0 }
    return selected_component, selected_component.free_space
  end
end

class Component
  [:occupied_space, :storage_capacity, :free_space].each do |message|
    define_method(message) do
      @sub_components.inject(0) { |acc, component| acc + component.send(message) }
    end
  end

  def initialize(sub_components, strategy)
    @sub_components = sub_components
    @strategy = strategy
  end

  def write(chars)
    until chars.empty?
      selected_component, number_of_items_to_write = @strategy.select(@sub_components, chars.size)
      p selected_component.inspect + 'blah' + number_of_items_to_write.to_s
      selected_component.write(chars.shift(number_of_items_to_write))
    end
    # Component.new(written_sub_components)
  end
end


[FirstFitStrategy, BestFitStrategy].each do |strategy|
  p "**************** with #{strategy} ************ "
  t1, t2 = LeafComponent.new(1), LeafComponent.new(3)
  p t1
  p t2
  c1 = Component.new([t1, t2], strategy)
  p c1
  p c1.occupied_space
  p c1.storage_capacity
  p "old components -> " + c1.inspect.to_s
  c1.write(['a','b','c'])
  p "new components -> " + c1.inspect.to_s
  c1.write(['d'])
  p "newer components -> " + c1.inspect.to_s
end





