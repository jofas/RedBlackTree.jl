# (!)
#
# All macros can only defined in functions where
# self::RBTree{T} exists
#
# (!)


macro get(property, node)
  if property == :(:color)
    return esc(:(color(self, $node)))

  elseif property == :(:grandparent)
    return esc(:(@get(:parent, @get(:parent, $node))))

  elseif property == :(:uncle)
    return esc(quote
      if is_left_child(self, @get(:parent, $node))
        @get :right @get(:grandparent, $node)
      else
        @get :left @get(:grandparent, $node)
      end
    end)
  end
  # here match property
  # and do stuff correspondingly
  return esc(:(
    getproperty(self.nodes[$node],$property)
  ))
end


macro set(property, node, val)
  if property == :(:parent)
    return esc(quote
      if $node != nothing
        setproperty!(self.nodes[$node], $property, $val)
      end
    end)
  end

  # here match property
  # and do stuff correspondingly
  return esc(:(
    setproperty!(self.nodes[$node], $property, $val)
  ))
end

# use this if direction is predetermined and if in no
# doubt that child is not nothing. Otherwise use set_child!
#
macro new_child(which, node, child)
  return esc(quote
    @set $which $node $child
    @set :parent $child $node
  end)
end


macro set_count(count, node, to)
  return esc(quote
    if $to != nothing
      @set $count $node ( @get(:count, $to) +
                          @get(:count_left, $to) +
                          @get(:count_right, $to) )
    else
      @set $count $node 0
    end
  end)
end


macro increment(property, node)
  return esc(:(
    @set $property $node (@get($property, $node) + 1)
  ))
end


macro is_nothing(property, node)
  return esc(:(@get($property, $node) == nothing))
end
