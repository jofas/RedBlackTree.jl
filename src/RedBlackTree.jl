module RedBlackTree

  export RBTree, geq

  import Base.==


  Base.Enums.@enum Color red black


  abstract type Nil end


  function Base.getproperty(n::DataType, p::Symbol)
    if n == Nil && p == :color return black end
    if n == Nil && p == :count return 0 end
    if n == Nil && p == :count_right return 0 end
    getfield(n, p)
  end


  mutable struct Node{T}
    color::Color
    key::T

    count::Int64
    count_right::Int64

    parent::Union{Node, DataType}
    left::Union{Node, DataType}
    right::Union{Node, DataType}
  end


  Node(key::T, parent::Union{Node{T}, DataType}) where T =
    Node(red, key, 1, 0, parent, Nil, Nil)


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
    root::Union{Node{T}, DataType}
  end


  RBTree{T}() where T = RBTree{T}(Nil)


  (==)(x::RBTree{T}, y::RBTree{T}) where T =
    x.root == y.root


  Base.insert!(self::RBTree{T}, keys...) where T =
    for key in keys insert!(self, key) end


  function Base.insert!(self::RBTree{T}, key) where T # {{{
    x, y = self.root, Nil

    while x != Nil
      y = x

      if key == x.key
        x.count += 1
        return
      elseif key < x.key
        x = x.left
      else
        x.count_right += 1
        x = x.right
      end
    end

    z = Node(key, y)

    if y == Nil
      self.root = z
    elseif key < y.key
      y.left = z
    else
      y.right = z
    end

    fixup!(self, z)
  end # }}}


  function geq(self::RBTree{T}, key::T)::Int64 where T # {{{
    count = 0

    x = self.root
    while x ≠ Nil
      if key ≤ x.key
        count += x.count + x.count_right
        x = x.left
      else
        x = x.right
      end
    end

    count
  end # }}}


  function fixup!(self::RBTree{T}, z::Node{T}) where T # {{{
    while z.parent.color == red

      if z.parent == z.parent.parent.left

        y = z.parent.parent.right

        if y.color == red

          # case 1
          z.parent.color = black
          y.color = black
          z.parent.parent.color = red
          z = z.parent.parent

        else

          # case 2
          if z == z.parent.right
            z = z.parent
            left_rotate!(self, z)
          end

          # case 3
          z.parent.color = black
          z.parent.parent.color = red
          right_rotate!(self, z.parent.parent)
        end

      else

        y = z.parent.parent.left

        if y.color == red

          # case 1
          z.parent.color = black
          y.color = black
          z.parent.parent.color = red
          z = z.parent.parent

        else

          # case 2
          if z == z.parent.left
            z = z.parent
            right_rotate!(self, z)
          end

          # case 3
          z.parent.color = black
          z.parent.parent.color = red
          left_rotate!(self, z.parent.parent)
        end

      end
    end

    self.root.color = black
  end # }}}


  function left_rotate!( self::RBTree{T}, z::Node{T} # ... {{{
                       ) where T
    y = z.right

    z.right = y.left

    if y.left != Nil
      y.left.parent = z
    end

    y.parent = z.parent

    if z.parent == Nil
      self.root = y
    elseif z == z.parent.left
      z.parent.left = y
    else
      z.parent.right = y
    end

    y.left = z
    z.parent = y

    z.count_right = Σₜᵣₑₑ(z.right)
  end # }}}


  function right_rotate!( self::RBTree{T}, z::Node{T} # ... {{{
                        ) where T
    y = z.left

    z.left = y.right

    if y.right != Nil
      y.right.parent = z
    end

    y.parent = z.parent

    if z.parent == Nil
      self.root = y
    elseif z == z.parent.left
      z.parent.left = y
    else
      z.parent.right = y
    end

    y.right = z
    z.parent = y

    y.count_right = Σₜᵣₑₑ(z)
  end # }}}


  Σₜᵣₑₑ(x::Node{T}) where T =
    x.count + Σₜᵣₑₑ(x.left) + Σₜᵣₑₑ(x.right)

  Σₜᵣₑₑ(x::DataType) = 0
end
