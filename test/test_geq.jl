@testset "test geq example" begin
  t = RBTree{Int64}()
  insert!(t, 1, 2, 5, 7, 8, 11, 14, 15, 4, 3, 6)

  @test geq(t,  1) == 11
  @test geq(t,  2) == 10
  @test geq(t,  3) == 9
  @test geq(t,  4) == 8
  @test geq(t,  5) == 7
  @test geq(t,  6) == 6
  @test geq(t,  7) == 5
  @test geq(t,  8) == 4
  @test geq(t,  9) == 3
  @test geq(t, 10) == 3
  @test geq(t, 11) == 3
  @test geq(t, 12) == 2
  @test geq(t, 13) == 2
  @test geq(t, 14) == 2
  @test geq(t, 15) == 1
  @test geq(t, 16) == 0
end


@testset "test geq random generated" begin
  for _ in 1:500
    arr = rand(500)

    t = RBTree{Float64}()

    insert!(t, arr...)

    cnt(arr) = [count(s -> s >= val, arr) for val in arr]

    @test geq.(t, arr) == cnt(arr)
  end
end
