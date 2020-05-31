module RedBlackTree

  export RBTree, geq, insertions


  import Base.==


  Base.Enums.@enum Color::Bool red black


  mutable struct Node

    count::Int64
    count_left::Int64
    count_right::Int64

    #parent::Union{Int64, Nothing}
    #left::Union{Int64, Nothing}
    #right::Union{Int64, Nothing}
  end


  Node() = Node(1, 0, 0)#, nothing, nothing)


  mutable struct RBTree{T}
    root::Union{Int64, Nothing}
    colors::Vector{Color}
    keys::Vector{T}

    parent::Vector{Union{Int64, Nothing}}
    left::Vector{Union{Int64, Nothing}}
    right::Vector{Union{Int64, Nothing}}

    count::Vector{Int64}
    count_left::Vector{Int64}
    count_right::Vector{Int64}
    #nodes::Vector{Node}
  end

  include("macros.jl")
  include("util.jl")
  include("fixup.jl")

  RBTree{T}() where T =
    RBTree{T}( nothing
             , Vector{Color}(undef, 0)
             , Vector{T}(undef, 0)
             , Vector{Union{Int64, Nothing}}(undef, 0)
             , Vector{Union{Int64, Nothing}}(undef, 0)
             , Vector{Union{Int64, Nothing}}(undef, 0)
             , Vector{Int64}(undef, 0)
             , Vector{Int64}(undef, 0)
             , Vector{Int64}(undef, 0)
             #, Vector{Node}(undef, 0)
             )


  Base.length(::RBTree{T}) where T = 1


  Base.iterate(self::RBTree{T}) where T = (self, nothing)
  Base.iterate(::RBTree{T}, ::Nothing) where T = nothing


  function Base.insert!(self::RBTree{T}, key::T) where T # {{{
    parent = get_leaf_and_update_count!(self, key)

    push!(self.colors, red)
    push!(self.keys, key)

    push!(self.parent, nothing)
    push!(self.left, nothing)
    push!(self.right, nothing)

    push!(self.count, 1)
    push!(self.count_left, 0)
    push!(self.count_right, 0)

    #push!(self.nodes, Node())

    child = length(self.keys)

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
    @get :count_sum self.root
end
