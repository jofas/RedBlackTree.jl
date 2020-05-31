macro increment(property, node)
  return esc(:(
    @set $property $node (@get($property, $node) + 1)
  ))
end


macro decrement(property, node)
  return esc(:(
    @set $property $node (@get($property, $node) - 1)
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


function decrease_path!(self::RBTree{T}, i::Int) where T
  while i ≠ self.root
    p = @get(:parent, i)

    if is_left_child(self, i)
      @decrement :count_left p
    else
      @decrement :count_right p
    end

    i = p
  end
end


function get_node(
    self::RBTree{T}, key::T)::Union{Int, Nothing} where T

  i = self.root

  while i ≠ nothing
    if key == @get :key i
      return i

    elseif key < @get :key i
      i = @get :left i

    else
      i = @get :right i

    end
  end

  nothing
end


function add_node!(self::RBTree{T}, key::T)::Int where T
  push!(self.color, red)
  push!(self.key, key)

  push!(self.parent, nothing)
  push!(self.left, nothing)
  push!(self.right, nothing)

  push!(self.count, 1)
  push!(self.count_left, 0)
  push!(self.count_right, 0)

  # pointer to the newly inserted node
  nodes(self)
end


function delete_node!(self::RBTree{T}, z::Int) where T
  y = z
  y_color = @get :color y

  if @get(:left, z) == nothing
    x = @get :right z
    transplant!(self, z, x)

  elseif @get(:right, z) == nothing
    x = @get :left z
    transplant!(self, z, x)

  else
    y = min_child(@get :right z)
    y_color = @get :color y

    x = @get :right y

    if @get(:parent, y) == z
      @set :parent x y
    else
      transplant!(self, y, @get :right y)
      @set :right y @get(:right, z)
      @set :right @get(:parent, @get(:right, z)) y
    end

    transplant!(self, z, y)
    @set :left y :get(:left, z)
    @set :left @get(:parent, y) y
    @set :color y @get(:color, z)
  end

  if y_color == black
    delete_fixup!(self, x)
  end
end


function transplant!(self::RBTree{T}, node1::Int, node2::Int) where T
  node1_parent = @get :parent node1

  if node1_parent == nothing
    self.root = node2

  elseif is_left_child(self, node1)
    @set :left node1_parent node2

  else
    @set :right node1_parent node2
  end

  @set :parent node2 node1_parent
end


function min_child( self::RBTree{T}, i::Union{Int, Nothing}
                  )::Union{Int, Nothing} where T

  while i ≠ nothing
    child = @get :left i

    if child == nothing
      break
    else
      i = child
    end
  end

  i
end


is_left_child(self::RBTree{T}, i::Union{Int, Nothing}
             ) where T =
  i == @get(:left, @get(:parent, i))


is_right_child(self::RBTree{T}, i::Union{Int, Nothing}
              ) where T =
  !is_left_child(self, i)
