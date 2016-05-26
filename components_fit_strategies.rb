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

  def leaf_node?
    true
  end
end

class Component
  attr_reader :sub_components
  [:occupied_space, :storage_capacity, :free_space].each do |message|
    define_method(message) do
      @sub_components.inject(0) { |acc, component| acc + component.send(message) }
    end
  end

  def initialize(sub_components, strategy)
    @sub_components = sub_components
    @strategy = strategy
  end
  
  def leaf_node?
    false
  end
end

module ComponentsWriter
  def write(chars, components)
    until chars.empty?
      selected_component, number_of_items_to_write = select(components, chars.size)
      if selected_component.leaf_node?
        selected_component.write(chars.shift(number_of_items_to_write))
      else
        self.write(chars.shift(number_of_items_to_write), selected_component.sub_components)
      end
    end
  end  
end

class BestFitStrategy
  include ComponentsWriter

  private
  def select(components, number_of_items)
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
  include ComponentsWriter

  private
  def select(components, number_of_items) 
    selected_component = components.find { |component| component.free_space != 0 }
    return selected_component, selected_component.free_space
  end
end


[FirstFitStrategy.new, BestFitStrategy.new].each do |strategy|
  p "**************** with #{strategy} ************ "
  t1, t2 = LeafComponent.new(1), LeafComponent.new(3)
  p t1
  p t2
  c1 = Component.new([t1, t2], strategy)
  p c1
  p c1.occupied_space
  p c1.storage_capacity
  p "old components -> " + c1.inspect.to_s
  strategy.write(['a','b','c'], [c1])
  p "new components -> " + c1.inspect.to_s
  strategy.write(['d'], [c1])
  p "newer components -> " + c1.inspect.to_s
end





