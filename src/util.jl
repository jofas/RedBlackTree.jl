function get_leaf_and_update_count!( self::RBTree{T}
                                   , key::T ) where T
  i = self.root

  while i != nothing

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


function add_node!( self::RBTree{T}
                   , key::T
                   , parent::Union{Int64, Nothing}
                   )::Int64 where T

  push!(self.nodes, Node(key, parent))
  length(self.nodes)
end


function set_child!( self::RBTree{T}
                   , parent::Int64
                   , child::Int64 ) where T
  if @get(:key, child) < @get(:key, parent)
    @set :left parent child
  else
    @set :right parent child
  end
end

set_child!( self::RBTree{T}, ::Nothing, child::Int64
          ) where T = self.root = child


is_left_child(self::RBTree{T}, i::Int64) where T =
  i == @get(:left, @get(:parent, i))


is_right_child(self::RBTree{T}, i::Int64) where T =
  i == @get(:right, @get(:parent, i))


color(self::RBTree{T}, i::Int64) where T =
  self.nodes[i].color

color(::RBTree{T}, ::Nothing) where T = black
