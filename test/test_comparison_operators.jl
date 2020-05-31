@testset "test >= with example I know the tree structure of" begin
  t = RBTree{Int64}()
  insert!.(t, [1, 2, 5, 7, 8, 11, 14, 15, 4, 3, 6])

  @test (t >=  1) == 11
  @test (t >=  2) == 10
  @test (t >=  3) == 9
  @test (t >=  4) == 8
  @test (t >=  5) == 7
  @test (t >=  6) == 6
  @test (t >=  7) == 5
  @test (t >=  8) == 4
  @test (t >=  9) == 3
  @test (t >= 10) == 3
  @test (t >= 11) == 3
  @test (t >= 12) == 2
  @test (t >= 13) == 2
  @test (t >= 14) == 2
  @test (t >= 15) == 1
  @test (t >= 16) == 0
end


@testset "test == with randomly generated keys" begin
  for _ in 1:500
    arr = rand(500)

    t = RBTree{Float64}()

    insert!.(t, arr)

    cnt(arr) = [count(s -> s == val, arr) for val in arr]

    @test (t .== arr) == cnt(arr)
  end
end


@testset "test < with randomly generated keys" begin
  for _ in 1:500
    arr = rand(500)

    t = RBTree{Float64}()

    insert!.(t, arr)

    cnt(arr) = [count(s -> s < val, arr) for val in arr]

    @test (t .< arr) == cnt(arr)
  end
end


@testset "test <= with randomly generated keys" begin
  for _ in 1:500
    arr = rand(500)

    t = RBTree{Float64}()

    insert!.(t, arr)

    cnt(arr) = [count(s -> s <= val, arr) for val in arr]

    @test (t .<= arr) == cnt(arr)
  end
end


@testset "test > with randomly generated keys" begin
  for _ in 1:500
    arr = rand(500)

    t = RBTree{Float64}()

    insert!.(t, arr)

    cnt(arr) = [count(s -> s > val, arr) for val in arr]

    @test (t .> arr) == cnt(arr)
  end
end


@testset "test >= with randomly generated keys" begin
  for _ in 1:500
    arr = rand(500)

    t = RBTree{Float64}()

    insert!.(t, arr)

    cnt(arr) = [count(s -> s >= val, arr) for val in arr]

    @test (t .>= arr) == cnt(arr)
  end
end
