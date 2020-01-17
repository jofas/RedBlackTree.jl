module RedBlackTree

  export RBTree, geq


  import Base.==


  Base.Enums.@enum Color red black


  # TODO: to property functions
  function Base.getproperty(::Nothing, p::Symbol)
    if p == :color       return black end
    if p == :count       return 0 end
    if p == :count_right return 0 end

    getfield(nothing, p)
  end


  mutable struct Node{T}
    color::Color
    key::T

    count::Int64
    count_right::Int64

    parent::Union{Int64, Nothing}
    left::Union{Int64, Nothing}
    right::Union{Int64, Nothing}
  end


  Node(key::T, parent::Union{Int64, Nothing}) where T =
    Node(red, key, 1, 0, parent, nothing, nothing)


  function (==)(x::Node{T}, y::Node{T}) where T
    # only left and right children are tested, since other-
    # wise a stack overflow will return, since an endless
    # count of recursive calls to == are made
    for s in ( :color, :key, :count, :count_right, :left
             , :right )
      if getproperty(x, s) != getproperty(y, s)
        return false
      end
    end
    true
  end


  mutable struct RBTree{T}
    root::Union{Int64, Nothing}
    nodes::Vector{Node{T}}
    # need to be counted, because amount of nodes not
    # necessarily equal to the amount of insertions
    insertions::Int64
  end


  RBTree{T}() where T =
    RBTree{T}(nothing, Vector{Node{T}}(undef, 0), 0)


  Base.length(::RBTree{T}) where T = 1


  Base.iterate(self::RBTree{T}) where T = (self, nothing)
  Base.iterate(::RBTree{T}, ::Nothing) where T = nothing


  function Base.insert!(self::RBTree{T}, key::T) where T # {{{
    self.insertions += 1

    if self.insertions == 1
      root = Node(key, nothing)
      root.color = black
      push!(self.nodes, root)
      self.root = 1
      return
    end

    i = self.root

    while true
      x = self.nodes[i]

      if key == x.key
        x.count += 1
        return

      elseif key < x.key
        x.left == nothing ? break : i = x.left

      else
        x.count_right += 1

        x.right == nothing ? break : i = x.right
      end
    end

    push!(self.nodes, Node(key, i))
    j = length(self.nodes)

    key < self.nodes[i].key ?
      self.nodes[i].left = j : self.nodes[i].right = j

    fixup!(self, j)
  end # }}}


  function geq(self::RBTree{T}, key::T)::Int64 where T # {{{
    count = 0

    i = self.root
    while i ≠ nothing
      if key ≤ self.nodes[i].key
        count +=
          self.nodes[i].count + self.nodes[i].count_right

        i = self.nodes[i].left
      else
        i = self.nodes[i].right
      end
    end

    count
  end # }}}


  function fixup!(self::RBTree{T}, i::Int64) where T # {{{
    while color(self, parent(self, i)) == red

      p = parent(self, i)
      gp = grandparent(self, i)


      if is_left_child(self, p)

        u = right_uncle(self, i)

        if color(self, u) == red

          # case 1
          self.nodes[p].color = black
          self.nodes[u].color = black
          self.nodes[gp].color = red
          i = gp
        else

          # case 2
          if is_right_child(self, i)
            i = p

            left_rotate!(self, i)

            p = parent(self, i)
            gp = grandparent(self, i)
          end

          # case 3
          self.nodes[p].color = black
          self.nodes[gp].color = red
          right_rotate!(self, gp)
        end

      else

        u = left_uncle(self, i)

        if color(self, u) == red

          # case 1
          self.nodes[p].color = black
          self.nodes[u].color = black
          self.nodes[gp].color = red
          i = gp

        else

          # case 2
          if is_left_child(self, i)
            i = p

            right_rotate!(self, i)

            p = parent(self, i)
            gp = grandparent(self, i)
          end

          # case 3
          self.nodes[p].color = black
          self.nodes[gp].color = red
          left_rotate!(self, gp)
        end

      end
    end

    self.nodes[self.root].color = black
  end # }}}


  function left_rotate!(self::RBTree{T}, i::Int64) where T
    j = right_child(self, i)
    lj = left_child(self, j)
    p = parent(self, i)

    self.nodes[i].right = lj

    if lj != nothing self.nodes[lj].parent = i end

    self.nodes[j].parent = p

    if p == nothing
      self.root = j
    elseif is_left_child(self, i)
      self.nodes[p].left = j
    else
      self.nodes[p].right = j
    end

    self.nodes[j].left = i
    self.nodes[i].parent = j

    self.nodes[i].count_right =
      Σₜᵣₑₑ(self, right_child(self, i))
  end


  function right_rotate!(self::RBTree{T}, i::Int64) where T
    j = left_child(self, i)
    rj = right_child(self, j)
    p = parent(self, i)

    self.nodes[i].left = rj

    if rj != nothing self.nodes[rj].parent = i end

    self.nodes[j].parent = p

    if p == nothing
      self.root = j
    elseif is_left_child(self, i)
      self.nodes[p].left = j
    else
      self.nodes[p].right = j
    end

    self.nodes[j].right = i
    self.nodes[i].parent = j

    self.nodes[j].count_right = Σₜᵣₑₑ(self, i)
  end


  Σₜᵣₑₑ(self::RBTree{T}, i::Int64) where T =
    self.nodes[i].count + Σₜᵣₑₑ(self, left_child(self, i)) +
                          Σₜᵣₑₑ(self, right_child(self, i))

  Σₜᵣₑₑ(::RBTree{T}, ::Nothing) where T = 0


  parent(self::RBTree{T}, i::Int64) where T =
    self.nodes[i].parent


  grandparent(self::RBTree{T}, i::Int64) where T =
    parent(self, parent(self, i))


  left_child(self::RBTree{T}, i::Int64) where T =
    self.nodes[i].left


  right_child(self::RBTree{T}, i::Int64) where T =
    self.nodes[i].right


  color(self::RBTree{T}, i::Int64) where T =
    self.nodes[i].color

  color(::RBTree{T}, ::Nothing) where T = black


  is_left_child(self::RBTree{T}, i::Int64) where T =
    i == left_child(self, parent(self, i))


  is_right_child(self::RBTree{T}, i::Int64) where T =
    i == right_child(self, parent(self, i))


  left_uncle(self::RBTree{T}, i::Int64) where T =
    left_child(self, grandparent(self, i))


  right_uncle(self::RBTree{T}, i::Int64) where T =
    right_child(self, grandparent(self, i))
end
