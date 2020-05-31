# (!)
#
# All macros can only defined in functions where
# self::RBTree{T} exists
#
# (!)


macro get(property, node)

  color(self::RBTree{T}, i::Int64) where T =
    self.colors[i]

  color(::RBTree{T}, ::Nothing) where T = black


  count_sum(self::RBTree{T}, i::Int64) where T =
    self.count[i] + self.count_left[i] + self.count_right[i]

  count_sum(::RBTree{T}, ::Nothing) where T = 0


  if property == :(:color)
    return esc(:($color(self, $node)))

  elseif property == :(:key)
    return esc(:(self.keys[$node]))

  elseif property == :(:parent)
    return esc(:(self.parent[$node]))

  elseif property == :(:left)
    return esc(:(self.left[$node]))

  elseif property == :(:right)
    return esc(:(self.right[$node]))

  elseif property == :(:count)
    return esc(:(self.count[$node]))

  elseif property == :(:count_left)
    return esc(:(self.count_left[$node]))

  elseif property == :(:count_right)
    return esc(:(self.count_right[$node]))

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

  if property == :(:color)
    return esc(:(self.colors[$node] = $val))

  elseif property == :(:parent)
    return esc(:(if $node != nothing self.parent[$node] = $val end))

  elseif property == :(:count)
    return esc(:(if $node != nothing self.count[$node] = $val end))

  elseif property == :(:count_left)
    return esc(:(if $node != nothing self.count_left[$node] = $val end))

  elseif property == :(:count_right)
    return esc(:(if $node != nothing self.count_right[$node] = $val end))

  end

  return esc(:(
    if $node != nothing

      # right and left must be matched here, because I use a variable
      # in fixup/set_child! so can't put it ahead of the runtime

      if $property == :right
        self.right[$node] = $val
      elseif $property == :left
        self.left[$node] = $val
      else
        setproperty!(self.nodes[$node], $property, $val)
      end
    end
  ))
end
