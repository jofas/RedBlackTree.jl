include("../src/RedBlackTree.jl")

using .RedBlackTree

using Test


include("test_tree_structure.jl")
include("test_comparison_operators.jl")


@testset "test insertions" begin
  for i in 1:500
    t = RBTree{Float64}()
    insert!.(t, rand(i))
    @test size(t) == i
  end
end


@testset "test nodes" begin
  t = RBTree{Int}()
  insert!.(t, [1 for _ in 1:500])
  @test nodes(t) == 1
end
