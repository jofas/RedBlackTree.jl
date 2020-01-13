@testset "test count_right" begin
  t = RBTree{Int64}()

  insert!(t, 1)

  @test t.root.count_right == 0

  insert!(t, 2)

  @test t.root.count_right == 1
  @test t.root.right.count_right == 0

  insert!(t, 5)

  @test t.root.count_right == 1
  @test t.root.left.count_right == 0
  @test t.root.right.count_right == 0

  insert!(t, 7)

  @test t.root.count_right == 2
  @test t.root.left.count_right == 0
  @test t.root.right.count_right == 1
  @test t.root.right.right.count_right == 0

  insert!(t, 8)

  @test t.root.count_right == 3
  @test t.root.left.count_right == 0
  @test t.root.right.count_right == 1
  @test t.root.right.left.count_right == 0
  @test t.root.right.right.count_right == 0

  insert!(t, 11)

  @test t.root.count_right == 4
  @test t.root.left.count_right == 0
  @test t.root.right.count_right == 2
  @test t.root.right.left.count_right == 0
  @test t.root.right.right.count_right == 1
  @test t.root.right.right.right.count_right == 0

  insert!(t, 14)

  @test t.root.count_right == 5
  @test t.root.left.count_right == 0
  @test t.root.right.count_right == 3
  @test t.root.right.left.count_right == 0
  @test t.root.right.right.count_right == 1
  @test t.root.right.right.left.count_right == 0
  @test t.root.right.right.right.count_right == 0

  insert!(t, 15)

  @test t.root.count_right == 4
  @test t.root.left.count_right == 1
  @test t.root.left.left.count_right == 0
  @test t.root.left.right.count_right == 0
  @test t.root.right.count_right == 2
  @test t.root.right.left.count_right == 0
  @test t.root.right.right.count_right == 1
  @test t.root.right.right.right.count_right == 0

  insert!(t, 4)

  @test t.root.count_right == 4
  @test t.root.left.count_right == 2
  @test t.root.left.left.count_right == 0
  @test t.root.left.right.count_right == 0
  @test t.root.left.right.left.count_right == 0
  @test t.root.right.count_right == 2
  @test t.root.right.left.count_right == 0
  @test t.root.right.right.count_right == 1
  @test t.root.right.right.right.count_right == 0

  insert!(t, 3)

  @test t.root.count_right == 4
  @test t.root.left.count_right == 3
  @test t.root.left.left.count_right == 0
  @test t.root.left.right.count_right == 1
  @test t.root.left.right.left.count_right == 0
  @test t.root.left.right.right.count_right == 0
  @test t.root.right.count_right == 2
  @test t.root.right.left.count_right == 0
  @test t.root.right.right.count_right == 1
  @test t.root.right.right.right.count_right == 0

  insert!(t, 6)

  @test t.root.count_right == 4
  @test t.root.left.count_right == 4
  @test t.root.left.left.count_right == 0
  @test t.root.left.right.count_right == 2
  @test t.root.left.right.left.count_right == 0
  @test t.root.left.right.right.count_right == 1
  @test t.root.left.right.right.right.count_right == 0
  @test t.root.right.count_right == 2
  @test t.root.right.left.count_right == 0
  @test t.root.right.right.count_right == 1
  @test t.root.right.right.right.count_right == 0
end

