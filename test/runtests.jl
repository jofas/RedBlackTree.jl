include("../src/RedBlackTree.jl")

using .RedBlackTree

using Test

include("test_insert.jl")
include("test_count_right.jl")
include("test_geq.jl")


@testset "test count" begin

  t = RBTree{Int64}()

  insert!(t, 1, 1, 1, 1)

  @test t.root.count == 4
end


@testset "test equality of trees" begin

  t1 = RBTree{Int64}()
  t2 = RBTree{Int64}()

  @test t1 == t2

  insert!(t1, 1, 2, 3, 3, 3)

  @test t1 != t2

  insert!(t2, 1, 2, 3, 3, 3)

  @test t1 == t2
end
