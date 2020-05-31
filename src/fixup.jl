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


# left_rotate! and right_rotate! {{{
for (dir, dirᵣₑᵥ, dir_count, dir_countᵣₑᵥ) in (
  (:(:left), :(:right), :(:count_left), :(:count_right)),
  (:(:right), :(:left), :(:count_right), :(:count_left))
)
  fn = dir == :(:left) ? (:left_rotate!) :
                         (:right_rotate!)

  @eval begin
    function $fn(self::RBTree{T}, rotator::Int) where T
      rotating_child = @get $dirᵣₑᵥ rotator
      new_child = @get $dir rotating_child


      $set_child!(self, rotator, new_child, $dirᵣₑᵥ)

      $set_child!( self, @get(:parent, rotator)
                 , rotating_child )

      $set_child!(self, rotating_child, rotator, $dir)


      @set $dir_countᵣₑᵥ rotator @get( :count_sum
                                     , new_child )

      @set $dir_count rotating_child @get( :count_sum
                                         , rotator )
    end
  end
end # }}}


# fixup_cases_left! and fixup_cases_right! {{{
for (dir, (c2_condition, c2_rotation, c3_rotation)) in (
  (:left, (:is_right_child, :left_rotate!, :right_rotate!)),
  (:right, (:is_left_child, :right_rotate!, :left_rotate!))
)
  fn = dir == :left ? (:fixup_cases_left!) :
                      (:fixup_cases_right!)

  @eval begin
    function $fn(self::RBTree{T}, node::Int) where T

      p  = @get :parent node
      u  = @get :uncle node
      gp = @get :grandparent node

      # case 1
      if @get(:color, u) == red
        @set :color p black
        @set :color u black
        @set :color gp red
        node = gp

      else

        # case 2
        if $c2_condition(self, node)
          node = p

          $c2_rotation(self, node)

          p = @get :parent node
          gp = @get :grandparent node
        end

        # case 3
        @set :color p black
        @set :color gp red
        $c3_rotation(self, gp)
      end

      node

    end
  end
end # }}}


function insert_fixup!( self::RBTree{T}, node::Int
                      , parent::Union{Int, Nothing} ) where T

  set_child!(self, parent, node)

  while @get(:color, parent) == red
    if is_left_child(self, parent)
      node = fixup_cases_left!(self, node)
    else
      node = fixup_cases_right!(self, node)
    end
    parent = @get :parent node
  end

  @set :color self.root black
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
