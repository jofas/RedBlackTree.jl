function generate_suite(sizes, benchmarks...)
  suite = BenchmarkGroup()

  for s in sizes
    suite[s] = BenchmarkGroup()

    for exp in benchmarks
      suite[s][exp.first] = @benchmarkable $exp.second[1](
        $s, Base.tail($exp.second)...
      )
    end
  end

  suite
end


function tune_or_load!(suite::BenchmarkGroup)
  FILE = "baseline_params.json"
  if isfile(FILE)
    params = BenchmarkTools.load(FILE)[1]
    loadparams!(suite, params, :evals, :samples)
  else
    tune!(suite)
    BenchmarkTools.save(FILE, BenchmarkTools.params(suite))
  end
end


function tree_count(arr::Vector{Float64})
  t = RBTree{Float64}()

  insert!.(t, arr)

  t .>= arr
end


function arr_count(arr::Vector{Float64})
  [count(s -> s >= k, arr) for k in arr]
end
