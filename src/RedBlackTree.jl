module RedBlackTree

  export RBTree, geq, insertions


  import Base.==


  Base.Enums.@enum Color::Bool red black


  mutable struct Node{T}
    color::Color
    key::T

    count::Int64
    count_left::Int64
    count_right::Int64

    parent::Union{Int64, Nothing}
    left::Union{Int64, Nothing}
    right::Union{Int64, Nothing}
  end


  Node(key::T, parent::Union{Int64, Nothing}) where T =
    Node(red, key, 1, 0, 0, parent, nothing, nothing)

  Node(key::T) where T =
    Node(red, key, 1, 0, 0, nothing, nothing, nothing)


  mutable struct RBTree{T}
    root::Union{Int64, Nothing}
    nodes::Vector{Node{T}}
  end


  include("macros.jl")
  include("util.jl")


  RBTree{T}() where T =
    RBTree{T}(nothing, Vector{Node{T}}(undef, 0))


  Base.length(::RBTree{T}) where T = 1


  Base.iterate(self::RBTree{T}) where T = (self, nothing)
  Base.iterate(::RBTree{T}, ::Nothing) where T = nothing


  function Base.insert!(self::RBTree{T}, key::T) where T # {{{
    parent = get_leaf_and_update_count!(self, key)

    push!(self.nodes, Node(key))
    child = length(self.nodes)

    @set_child parent child

    fixup!(self, child)
  end # }}}


  function geq(self::RBTree{T}, key::T)::Int64 where T # {{{
    count = 0

    i = self.root
    while i ≠ nothing
      if key ≤ @get :key i

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


  function fixup!(self::RBTree{T}, i::Int64) where T # {{{
    while @get(:color, @get(:parent, i)) == red

      p = @get :parent i
      gp = @get :grandparent i


      if is_left_child(self, p)

        u = @get :uncle i

        if @get(:color, u) == red

          # case 1
          @set :color p black
          @set :color u black
          @set :color gp red
          i = gp
        else

          # case 2
          if is_right_child(self, i)
            i = p

            left_rotate!(self, i)

            p = @get :parent i
            gp = @get :grandparent i
          end

          # case 3
          @set :color p black
          @set :color gp red
          right_rotate!(self, gp)
        end

      else

        u = @get :uncle i

        if @get(:color, u) == red

          # case 1
          @set :color p black
          @set :color u black
          @set :color gp red
          i = gp

        else

          # case 2
          if is_left_child(self, i)
            i = p

            right_rotate!(self, i)

            p = @get :parent i
            gp = @get :grandparent i
          end

          # case 3
          @set :color p black
          @set :color gp red
          left_rotate!(self, gp)
        end

      end
    end

    @set :color self.root black
  end # }}}


  # left_rotate! and right_rotate! {{{
  for (dir, dirᵣₑᵥ, dir_count, dir_countᵣₑᵥ) in (
    (:(:left), :(:right), :(:count_left), :(:count_right)),
    (:(:right), :(:left), :(:count_right), :(:count_left))
  )
    fn = dir == :(:left) ? (:left_rotate!) :
                           (:right_rotate!)

    @eval begin
      function $fn(self::RBTree{T}, rotator::Int64) where T
        rotating_child = @get $dirᵣₑᵥ rotator
        new_child = @get $dir rotating_child

        @set_child_unchecked $dirᵣₑᵥ rotator new_child

        @set_child @get(:parent, rotator) rotating_child

        @set_child_unchecked $dir rotating_child rotator

        # rotator must be set first, because otherwise the
        # value for the rotating child will be wrong
        @set_count $dir_countᵣₑᵥ rotator new_child
        @set_count $dir_count rotating_child rotator
      end
    end
  end
  # }}}
end
