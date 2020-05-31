function set_child!( self::RBTree{T}
                   , node::Int64
                   , child::Int64 ) where T
  @get(:key, child) < @get(:key, node) ?
    set_child!(self, node, child, :left) :
    set_child!(self, node, child, :right)
end


function set_child!( self::RBTree{T}, ::Nothing
                   , child::Int64 ) where T
  @set :parent child nothing
  self.root = child
end


function set_child!( self::RBTree{T}
                   , node::Int64
                   , child::Union{Int64, Nothing}
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
    function $fn(self::RBTree{T}, rotator::Int64) where T
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
    function $fn(self::RBTree{T}, node::Int64) where T

      p  = @get :parent node
      u  = @get :uncle node
      gp = @get :grandparent node

      if @get(:color, u) == red

        # case 1
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


function fixup!( self::RBTree{T}, node::Int64
               , parent::Union{Int64, Nothing} ) where T

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
