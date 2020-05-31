# (!)
#
# All macros can only defined in functions where
# self::RBTree{T} exists
#
# (!)


macro get(property, node) # {{{

  color(self::RBTree{T}, i::Int) where T =
    self.color[i]

  color(::RBTree{T}, ::Nothing) where T = black


  count_sum(self::RBTree{T}, i::Int) where T =
    self.count[i] + self.count_left[i] + self.count_right[i]

  count_sum(::RBTree{T}, ::Nothing) where T = 0

  # here some properties are generated on the fly which are not part
  # of the RBTree instance
  #
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


  return esc(:(
    getproperty(self, $property)[$node]
  ))
end # }}}


macro set(property::QuoteNode, node, val)
  return esc(:(
    if $node != nothing
      getproperty(self, $property)[$node] = $val
    end
  ))
end


macro set(property::Symbol, node, val)
  return esc(:(
    if $node != nothing

      # right and left must be matched here, because I use a variable
      # in fixup/set_child! so can't put it ahead of the runtime

      if $property == :right
        self.right[$node] = $val
      elseif $property == :left
        self.left[$node] = $val
      end
    end
  ))
end
