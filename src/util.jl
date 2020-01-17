function get_leaf_and_update_count!( self::RBTree{T}
                                   , key::T ) where T
  i = self.root

  while i ≠ nothing

    if key == @get :key i
      @increment :count i
      break

    elseif key < @get :key i
      @increment :count_left i
      @is_nothing(:left, i) ? break : i = @get :left i

    else
      @increment :count_right i
      @is_nothing(:right, i) ? break : i = @get :right i
    end
  end

  i
end


is_left_child(self::RBTree{T}, i::Int64) where T =
  i == @get(:left, @get(:parent, i))


is_right_child(self::RBTree{T}, i::Int64) where T =
  i == @get(:right, @get(:parent, i))
