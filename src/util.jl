macro increment(property, node)
  return esc(:(
    @set $property $node (@get($property, $node) + 1)
  ))
end


macro is_nothing(property, node)
  return esc(:(@get($property, $node) == nothing))
end


function get_leaf_and_update_count!(
    self::RBTree{T}, key::T)::Tuple{Union{Int, Nothing}, Bool} where T

  i = self.root
  already_exists = false

  while i ≠ nothing

    if key == @get :key i
      @increment :count i
      already_exists = true
      break

    elseif key < @get :key i
      @increment :count_left i
      @is_nothing(:left, i) ? break : i = @get :left i

    else
      @increment :count_right i
      @is_nothing(:right, i) ? break : i = @get :right i
    end
  end

  (i, already_exists)
end


# needed in @get and @fixup
is_left_child(self::RBTree{T}, i::Union{Int, Nothing}
             ) where T =
  i == @get(:left, @get(:parent, i))


is_right_child(self::RBTree{T}, i::Union{Int, Nothing}
              ) where T =
  !is_left_child(self, i)
