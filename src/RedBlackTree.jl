module RedBlackTree

  export RBTree, insertions


  import Base.==, Base.<, Base.<=, Base.>, Base.>=


  Base.Enums.@enum Color::Bool red black


  mutable struct RBTree{T}
    root::Union{Int64, Nothing}
    color::Vector{Color}
    key::Vector{T}

    parent::Vector{Union{Int64, Nothing}}
    left::Vector{Union{Int64, Nothing}}
    right::Vector{Union{Int64, Nothing}}

    count::Vector{Int64}
    count_left::Vector{Int64}
    count_right::Vector{Int64}
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
             )


  # needed for broadcasting
  Base.length(::RBTree{T}) where T = 1

  Base.iterate(self::RBTree{T}) where T = (self, nothing)
  Base.iterate(::RBTree{T}, ::Nothing) where T = nothing


  function Base.insert!(self::RBTree{T}, key::T) where T # {{{
    parent = get_leaf_and_update_count!(self, key)

    push!(self.color, red)
    push!(self.key, key)

    push!(self.parent, nothing)
    push!(self.left, nothing)
    push!(self.right, nothing)

    push!(self.count, 1)
    push!(self.count_left, 0)
    push!(self.count_right, 0)

    child = length(self.key)

    fixup!(self, child, parent)
  end # }}}


  # ==, <, <=, >, >= {{{
  for (op, eq, l, r) in (
    ( :(==), :(@get :count i)
           , 0
           , 0 ),
    (  :(<), :(@get :count_left i)
           , 0
           , :(@get(:count, i) + @get(:count_left, i)) ),
    ( :(<=), :(@get(:count, i) + @get(:count_left, i))
           , 0
           , :(@get(:count, i) + @get(:count_left, i)) ),
    (  :(>), :(@get :count_right i)
           , :(@get(:count, i) + @get(:count_right, i))
           , 0 ),
    ( :(>=), :(@get(:count, i) + @get(:count_right, i))
           , :(@get(:count, i) + @get(:count_right, i))
           , 0 )
  )

    @eval begin
      function $op(self::RBTree{T}, key::T)::Int64 where T
        count = 0

        i = self.root

        while i ≠ nothing
          if key == @get :key i
            count += $eq
            break

          elseif key < @get :key i
            count += $l
            i = @get :left i

          else
            count += $r
            i = @get :right i
          end
        end

        count
      end
    end
  end # }}}


  insertions(self::RBTree{T}) where T =
    @get :count_sum self.root
end
