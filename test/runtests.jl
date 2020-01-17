include("../src/RedBlackTree.jl")

using .RedBlackTree

using Test


include("test_insert.jl")
include("test_geq.jl")


@testset "test count" begin

  t = RBTree{Int64}()

  insert!.(t, [1, 1, 1, 1])

  @test t.nodes[1].count == 4
end


@testset "test insertions field" begin
  for i in 1:500
    t = RBTree{Float64}()
    insert!.(t, rand(i))
    @test t.insertions == i
  end
end
