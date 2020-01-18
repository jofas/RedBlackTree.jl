include("../src/RedBlackTree.jl")

using .RedBlackTree

using Test


#include("test_insert.jl")
include("test_geq.jl")


@testset "test insertions" begin
  for i in 1:500
    t = RBTree{Float64}()
    insert!.(t, rand(i))
    @test insertions(t) == i
  end
end
