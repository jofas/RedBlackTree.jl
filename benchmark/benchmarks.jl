include("../src/RedBlackTree.jl")

using .RedBlackTree

using Pkg

Pkg.add("BenchmarkTools")

using BenchmarkTools

using Statistics


# TODO:
#       regression test time + mem/allocs


function tree_count(arr::Vector{Float64})
  t = RBTree{Float64}()

  insert!(t, arr...)

  [geq(t, k) for k in arr]
end


function arr_count(arr::Vector{Float64})
  [count(s -> s >= k, arr) for k in arr]
end


for r in [100_000, 150_000, 200_000]

  t = @benchmark tree_count(rand($r))
  c = @benchmark arr_count(rand($r))

  println(r)

  println("memory")
  println( "t: ", memory(t), " c: ", memory(c)
         , " ratio: ", ratio(memory(t), memory(c)) )

  println("allocs")
  println("t: ", allocs(t), " c: ", allocs(c)
         , " ratio: ", ratio(allocs(t), allocs(c)) )

  println("median")
  println("t: ", median(t), " c: ", median(c)
         , " ratio: ", ratio(median(t), median(c)) )

  println("mean")
  println("t: ", mean(t), " c: ", mean(c)
         , " ratio: ", ratio(mean(t), mean(c)) )

  println()
end
