include("../src/RedBlackTree.jl")

using .RedBlackTree

using Pkg

Pkg.add("BenchmarkTools")
Pkg.add("Fire")

using BenchmarkTools, Fire

using Statistics


const test_sizes = [150_000, 200_000]


macro regression_out(name, result, base)
  print_(descr, bench) =
    println(descr, ": ", repr("text/plain", bench))

  return esc(quote
    $print_("baseline $($name)", $base)
    $print_("result $($name)", $result)
    $print_( "compare $($name)"
           , judge( $result, $base, time_tolerance=0.1
                  , memory_tolerance=0.05 ) )
  end)
end


@main function regression()
  res  = test_regression()
  base = BenchmarkTools.load("baseline.json")[1]

  for r in test_sizes
    res_insert  = median(res[r]["insert"])
    base_insert = median(base[string(r)]["insert"])

    res_geq  = median(res[r]["geq"])
    base_geq = median(base[string(r)]["geq"])

    println(r)

    @regression_out "insert" res_insert base_insert
    @regression_out "geq" res_geq base_geq
  end
end


@main function create_baseline()
  res = test_regression()

  for r in test_sizes
    ins = median(res[r]["insert"])
    geq = median(res[r]["geq"])

    println(r)
    println("insert: ", repr("text/plain", ins))
    println("geq: ", repr("text/plain", geq))
  end

  BenchmarkTools.save("baseline.json", res)
end


@main function vs_naive()
  suite = BenchmarkGroup()

  for r in test_sizes
    suite[r] = BenchmarkGroup()

    suite[r]["tree"] = @benchmarkable tree_count(rand($r))
    suite[r]["naive"] = @benchmarkable arr_count(rand($r))
  end

  tune!(suite)
  res = run(suite)

  for r in test_sizes
    t = median(res[r]["tree"])
    n = median(res[r]["naive"])

    println(r)
    println("tree: ", repr("text/plain", t))
    println("naive: ", repr("text/plain", n))
    println("comp: ", repr("text/plain", judge(t, n)))
  end
end


function test_regression()
  suite = BenchmarkGroup()

  t = RBTree{Float64}()

  for r in test_sizes
    suite[r] = BenchmarkGroup()

    suite[r]["insert"] =
      @benchmarkable insert!($t, rand($r)...)
    suite[r]["geq"] =
      @benchmarkable [geq($t, k) for k in rand($r)]
  end

  tune!(suite)
  run(suite)
end


function tree_count(arr::Vector{Float64})
  t = RBTree{Float64}()

  insert!(t, arr...)

  [geq(t, k) for k in arr]
end


function arr_count(arr::Vector{Float64})
  [count(s -> s >= k, arr) for k in arr]
end
