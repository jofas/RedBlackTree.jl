macro regression_out(result, baseline, sizes, criteria)
  return esc(quote
    criteria = eval($criteria)

    for s in $sizes
      println(s)

      local res_insert  = criteria($result[s]["insert"])
      local base_insert =
        criteria($baseline[string(s)]["insert"])

      grouped_out( "baseline insert" => base_insert
                 , "result insert " => res_insert
                 , comparison = true )


      local res_geq  = criteria($result[s]["geq"])
      local base_geq = criteria($baseline[string(s)]["geq"])

      grouped_out( "baseline geq" => base_geq
                 , "result geq" => res_geq
                 , comparison = true )
    end
  end)
end


macro bench_out( result, sizes, criteria, indices
               , compare=false )

  return esc(quote
    criteria = eval($criteria)

    for s in $sizes
      println(s)

      local r1 = criteria($result[s][$indices[1]])
      local r2 = criteria($result[s][$indices[2]])

      grouped_out( $indices[1] => r1, $indices[2] => r2
                 , comparison = $compare )
    end
  end)
end


function grouped_out(r1::Pair, r2::Pair; comparison=false)
  println(r1.first, ": ", bench_to_str(r1.second))
  println(r2.first, ": ", bench_to_str(r2.second))

  if comparison compare_out(r2.second, r1.second) end
end


function compare_out(r1, r2)
  j = judge( r1, r2, time_tolerance=0.1
           , memory_tolerance=0.05 )

  println("comparison: ", bench_to_str(j))
end


function bench_to_str(bench)
  repr("text/plain", bench)
end
