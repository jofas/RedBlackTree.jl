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


is_left_child(self::RBTree{T}, i::Union{Int, Nothing}
             ) where T =
  i == @get(:left, @get(:parent, i))


is_right_child(self::RBTree{T}, i::Union{Int, Nothing}
              ) where T =
  !is_left_child(self, i)


function set_child!( self::RBTree{T}
                   , node::Int
                   , child::Int ) where T
  @get(:key, child) < @get(:key, node) ?
    set_child!(self, node, child, :left) :
    set_child!(self, node, child, :right)
end


function set_child!( self::RBTree{T}, ::Nothing
                   , child::Int ) where T
  @set :parent child nothing
  self.root = child
end


function set_child!( self::RBTree{T}
                   , node::Int
                   , child::Union{Int, Nothing}
                   , which::Symbol ) where T
  @set which   node  child
  @set :parent child node
end


