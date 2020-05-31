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


@testset "test min and max with randomly generated keys" begin
  for i in 1:500
    arr = rand(500)

    t = RBTree{Float64}()

    insert!.(t, arr)

    @test min(t) == min(arr...)
    @test max(t) == max(arr...)
  end
end


@testset "test delete when node has count > 1" begin
  t = RBTree{Int}()

  insert!.(t, [1, 1])

  delete!(t, 1)

  @test (t == 1) == 1
end

@testset "test delete with non-existent element" begin
  t = RBTree{Int}()

  insert!(t, 1)

  delete!(t, 2)

  @test size(t) == 1
end


@testset "test delete with randomly generated keys and >=" begin
  arr = rand(500)

  t = RBTree{Float64}()

  insert!.(t, arr)

  for i in 500:-1:1
    delete!(t, arr[i])
    pop!(arr)

    cnt(arr) = [count(s -> s >= val, arr) for val in arr]

    @test (t .>= arr) == cnt(arr)
  end
end
