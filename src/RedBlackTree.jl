module RedBlackTree

  export RBTree, nodes


  import Base.==, Base.<, Base.<=, Base.>, Base.>=


  Base.Enums.@enum Color::Bool red black


  mutable struct RBTree{T}
    root::Union{Int, Nothing}

    color::Vector{Color}
    key::Vector{T}

    parent::Vector{Union{Int, Nothing}}
    left::Vector{Union{Int, Nothing}}
    right::Vector{Union{Int, Nothing}}

    count::Vector{Int}
    count_left::Vector{Int}
    count_right::Vector{Int}
  end


  include("macros.jl")
  include("util.jl")
  include("fixup.jl")


  RBTree{T}() where T =
    RBTree{T}( nothing
             , Vector{Color}(undef, 0)
             , Vector{T}(undef, 0)
             , Vector{Union{Int, Nothing}}(undef, 0)
             , Vector{Union{Int, Nothing}}(undef, 0)
             , Vector{Union{Int, Nothing}}(undef, 0)
             , Vector{Int}(undef, 0)
             , Vector{Int}(undef, 0)
             , Vector{Int}(undef, 0)
             )


  # needed for broadcasting
  Base.length(::RBTree{T}) where T = 1

  Base.iterate(self::RBTree{T}) where T = (self, nothing)
  Base.iterate(::RBTree{T}, ::Nothing) where T = nothing


  function Base.insert!(self::RBTree{T}, key::T) where T # {{{
    parent, already_exists = get_leaf_and_update_count!(self, key)

    if !already_exists
      child = add_node!(self, key)

      # build the pointer structure in order to maintain the tree
      insert_fixup!(self, child, parent)
    end
  end # }}}


  function Base.delete!(self::RBTree{T}, key::T) where T # {{{
    z = get_node(self, key)

    if z ≠ nothing
      decrease_path!(self, z)

      count = @get :count z

      if count > 0
        @decrement :count z
      end


      #= TODO
      if count == 1

        delete_node!(self, z)

        # TODO: remove all the elements from the vectors (deleteat!)
        #delete!
        # not trivial with indices and broadcast
      else
        @set(:count, z, count - 1)
      end
      =#
    end
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
      function $op(self::RBTree{T}, key::T)::Int where T
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


  Base.size(self::RBTree{T}) where T =
    @get :count_sum self.root


  # min and max {{{
  for (fn, direction) in ((:min, :(:left)), (:max, :(:right)))
    @eval begin
      function Base.$fn(self::RBTree{T})::Union{T, Nothing} where T
        i = self.root

        while i ≠ nothing
          child = @get $direction i

          if child == nothing
            break
          else
            i = child
          end
        end

        i == nothing ? nothing : @get :key i
      end
    end
  end # }}}


  nodes(self::RBTree{T}) where T = length(self.color)
end
