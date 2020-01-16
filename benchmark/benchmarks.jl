include("../src/RedBlackTree.jl")

using .RedBlackTree

using Pkg

Pkg.add("BenchmarkTools")
Pkg.add("Fire")

using BenchmarkTools, Fire

using Statistics

include("out.jl")
include("util.jl")


@main function regression(criteria::Symbol = :median)
  base = BenchmarkTools.load("baseline.json")[1]
  sizes = parse.(Int64, keys(base))
  res  = bench_regression(sizes)
  @regression_out res base sizes criteria
end


@main function create_baseline( size::Int64
                              , sizes::Int64...
                              ; criteria::Symbol = :median
                              )

  sizes = (size, sizes...)
  res = bench_regression(sizes)
  @bench_out res sizes criteria ("insert", "geq")

  BenchmarkTools.save("baseline.json", res)
end


@main function vs_naive( size::Int64
                       , sizes::Int64...
                       ; criteria::Symbol = :median )

  sizes = (size, sizes...)

  suite =
    generate_suite( sizes
                  , "tree" => (s -> tree_count(rand(s)), )
                  , "naive" => (s -> arr_count(rand(s)), )
                  )

  tune!(suite)
  res = run(suite)

  @bench_out res sizes criteria ("tree", "naive") true
end


function bench_regression(sizes)
  t = RBTree{Float64}()

  insert_(size, tree) = insert!.(tree, rand(size))
  geq_(size, tree) = geq.(t, rand(size))

  suite = generate_suite( sizes
                        , "insert" => (insert_, t)
                        , "geq" => (geq_, t) )

  tune_or_load!(suite)

  run(suite)
end
