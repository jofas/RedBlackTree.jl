# (!)
#
# All macros can only defined in functions where
# self::RBTree{T} exists
#
# (!)


macro get(property, node)

  color(self::RBTree{T}, i::Int64) where T =
    self.nodes[i].color

  color(::RBTree{T}, ::Nothing) where T = black


  count_sum(self::RBTree{T}, i::Int64) where T =
    self.nodes[i].count + self.nodes[i].count_left +
                          self.nodes[i].count_right

  count_sum(::RBTree{T}, ::Nothing) where T = 0


  if property == :(:color)
    return esc(:($color(self, $node)))

  elseif property == :(:count_sum)
    return esc(:($count_sum(self, $node)))

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

  # here match property
  # and do stuff correspondingly
  return esc(:(
    if $node != nothing
      setproperty!(self.nodes[$node], $property, $val)
    end
  ))
end
