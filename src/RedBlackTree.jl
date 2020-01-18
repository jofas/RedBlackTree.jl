module RedBlackTree

  export RBTree, geq, insertions, @count


  import Base.==


  Base.Enums.@enum Color::Bool red black


  mutable struct Node
    count::Int64
    count_left::Int64
    count_right::Int64

    parent::Union{Int64, Nothing}
    left::Union{Int64, Nothing}
    right::Union{Int64, Nothing}
  end


  Node() = Node(1, 0, 0, nothing, nothing, nothing)


  mutable struct RBTree{T}
    root::Union{Int64, Nothing}
    colors::Vector{Color}
    keys::Vector{T}
    nodes::Vector{Node}
  end

  include("macros.jl")
  include("util.jl")
  include("fixup.jl")

  RBTree{T}() where T =
    RBTree{T}( nothing
             , Vector{Color}(undef, 0)
             , Vector{T}(undef, 0)
             , Vector{Node}(undef, 0)
             )


  Base.length(::RBTree{T}) where T = 1


  Base.iterate(self::RBTree{T}) where T = (self, nothing)
  Base.iterate(::RBTree{T}, ::Nothing) where T = nothing


  function Base.insert!(self::RBTree{T}, key::T) where T # {{{
    parent = get_leaf_and_update_count!(self, key)

    push!(self.colors, red)
    push!(self.keys, key)
    push!(self.nodes, Node())

    child = length(self.nodes)

    fixup!(self, child, parent)
  end # }}}


  function geq(self::RBTree{T}, key::T)::Int64 where T # {{{

    count = 0

    i = self.root
    while i ≠ nothing
      if key == @get :key i
        count += @get(:count, i) + @get(:count_right, i)
        break

      elseif key < @get :key i
        count += @get(:count, i) + @get(:count_right, i)
        i = @get :left i

      else
        i = @get :right i
      end
    end

    count
  end # }}}


  insertions(self::RBTree{T}) where T =
    @get(:count, self.root) +
    @get(:count_left, self.root) +
    @get(:count_right, self.root)
end
