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


@testset "test capacity vector alloc" begin
  c = CapacityVector{Float64}(100)

  @test size(c.container, 1) == 100

  push!.(c, rand(100))

  @test size(c.container, 1) == 100

  push!(c, rand())

  @test size(c.container, 1) == 200
end


@testset "test capacity vector indices" begin
  c = CapacityVector{Float64}(1)

  e = rand()

  push!(c, e)

  @test c[1] == e

  c[1] = 2.0

  @test c[1] == 2.0
end
