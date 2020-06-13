function delete_node!(self::RBTree{T}, z::Int) where T
  y = z
  y_color = @get :color y

  #=
  if @get(:left, z) == nothing && @get(:right, z) == nothing
    if is_left_child(self, z)
      @set :left @get(:parent, z) nothing
    else
      @set :right @get(:parent, z) nothing
    end
    return
  =#
  if @get(:left, z) == nothing
    x = @get :right z
    transplant!(self, z, x)

  elseif @get(:right, z) == nothing
    x = @get :left z
    transplant!(self, z, x)

  else
    y = min_child(self, @get :right z)
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
    @set :left y @get(:left, z)
    @set :left @get(:parent, y) y
    @set :color y @get(:color, z)
  end

  if y_color == black
    delete_fixup!(self, x)
  end
end


function transplant!( self::RBTree{T}, node1::Int
                    , node2::Union{Int, Nothing} ) where T
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


# delete_fixup_cases_left! and delete_fixup_cases_right! {{{
for (dir, rev, c14_rotation, c3_rotation) in (
  (:(:left), :(:right), :left_rotate!, :right_rotate!),
  (:(:right), :(:left), :right_rotate!, :left_rotate!)
)

  fn = dir == :(:left) ? (:delete_fixup_cases_left!) :
                         (:delete_fixup_cases_right!)

  @eval begin
    function $fn(self::RBTree{T}, node::Int) where T

      p  = @get :parent node

      w = @get $rev parent

      # case 1
      if @get(:color, w) == red
        @set :color w black
        @set :color p red
        $c14_rotation(self, parent)
        w = @get $rev p
      end

      l = @get :left w
      r = @get :right w

      # case 2
      if @get(:color, l) == black && @get(:color, r) == black
        @set :color w red
        node = @get :parent node

      # case 3
      elseif @get(:color, @get($rev, w)) == black
        @set :color @get($dir, w) black
        @set :color w red
        $c3_rotation(self, w)
      end

      # case 4
      p = @get :parent node

      c = @get $rev w

      @set :color w @get(:color, p)
      @set :color p black
      @set :color c black
      $c14_rotation(self, p)
      node = self.root

      node
    end
  end
end # }}}


function delete_fixup!(self::RBTree{T}, node::Int) where T
  while node ≠ self.root && @get(:color, node) == black
    if is_left_child(self, node)
      node = delete_fixup_cases_left!(self, node)
    else
      node = delete_fixup_cases_right!(self, node)
    end
  end

  @set :color node black
end
