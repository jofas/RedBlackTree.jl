@testset "test insert" begin

  t = RBTree{Int64}()

  insert!(t, 1)

  @test t.root.key == 1
  @test t.root.color == RedBlackTree.black


  insert!(t, 2)

  @test t.root.right.key == 2
  @test t.root.right.color == RedBlackTree.red


  insert!(t, 5)

  @test t.root.key == 2
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 1
  @test t.root.left.color == RedBlackTree.red

  @test t.root.right.key == 5
  @test t.root.right.color == RedBlackTree.red


  insert!(t, 7)

  @test t.root.key == 2
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 1
  @test t.root.left.color == RedBlackTree.black

  @test t.root.right.key == 5
  @test t.root.right.color == RedBlackTree.black

  @test t.root.right.right.key == 7
  @test t.root.right.right.color == RedBlackTree.red


  insert!(t, 8)

  @test t.root.key == 2
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 1
  @test t.root.left.color == RedBlackTree.black

  @test t.root.right.key == 7
  @test t.root.right.color == RedBlackTree.black

  @test t.root.right.left.key == 5
  @test t.root.right.left.color == RedBlackTree.red

  @test t.root.right.right.key == 8
  @test t.root.right.right.color == RedBlackTree.red


  insert!(t, 11)

  @test t.root.key == 2
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 1
  @test t.root.left.color == RedBlackTree.black

  @test t.root.right.key == 7
  @test t.root.right.color == RedBlackTree.red

  @test t.root.right.left.key == 5
  @test t.root.right.left.color == RedBlackTree.black

  @test t.root.right.right.key == 8
  @test t.root.right.right.color == RedBlackTree.black

  @test t.root.right.right.right.key == 11
  @test t.root.right.right.right.color == RedBlackTree.red


  insert!(t, 14)

  @test t.root.key == 2
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 1
  @test t.root.left.color == RedBlackTree.black

  @test t.root.right.key == 7
  @test t.root.right.color == RedBlackTree.red

  @test t.root.right.left.key == 5
  @test t.root.right.left.color == RedBlackTree.black

  @test t.root.right.right.key == 11
  @test t.root.right.right.color == RedBlackTree.black

  @test t.root.right.right.left.key == 8
  @test t.root.right.right.left.color == RedBlackTree.red

  @test t.root.right.right.right.key == 14
  @test t.root.right.right.right.color == RedBlackTree.red


  insert!(t, 15)

  @test t.root.key == 7
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 2
  @test t.root.left.color == RedBlackTree.red

  @test t.root.left.left.key == 1
  @test t.root.left.left.color == RedBlackTree.black

  @test t.root.left.right.key == 5
  @test t.root.left.right.color == RedBlackTree.black

  @test t.root.right.key == 11
  @test t.root.right.color == RedBlackTree.red

  @test t.root.right.left.key == 8
  @test t.root.right.left.color == RedBlackTree.black

  @test t.root.right.right.key == 14
  @test t.root.right.right.color == RedBlackTree.black

  @test t.root.right.right.right.key == 15
  @test t.root.right.right.right.color == RedBlackTree.red


  insert!(t, 4)

  @test t.root.key == 7
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 2
  @test t.root.left.color == RedBlackTree.red

  @test t.root.left.left.key == 1
  @test t.root.left.left.color == RedBlackTree.black

  @test t.root.left.right.key == 5
  @test t.root.left.right.color == RedBlackTree.black

  @test t.root.left.right.left.key == 4
  @test t.root.left.right.left.color == RedBlackTree.red

  @test t.root.right.key == 11
  @test t.root.right.color == RedBlackTree.red

  @test t.root.right.left.key == 8
  @test t.root.right.left.color == RedBlackTree.black

  @test t.root.right.right.key == 14
  @test t.root.right.right.color == RedBlackTree.black

  @test t.root.right.right.right.key == 15
  @test t.root.right.right.right.color == RedBlackTree.red


  insert!(t, 3)

  @test t.root.key == 7
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 2
  @test t.root.left.color == RedBlackTree.red

  @test t.root.left.left.key == 1
  @test t.root.left.left.color == RedBlackTree.black

  @test t.root.left.right.key == 4
  @test t.root.left.right.color == RedBlackTree.black

  @test t.root.left.right.left.key == 3
  @test t.root.left.right.left.color == RedBlackTree.red

  @test t.root.left.right.right.key == 5
  @test t.root.left.right.right.color == RedBlackTree.red

  @test t.root.right.key == 11
  @test t.root.right.color == RedBlackTree.red

  @test t.root.right.left.key == 8
  @test t.root.right.left.color == RedBlackTree.black

  @test t.root.right.right.key == 14
  @test t.root.right.right.color == RedBlackTree.black

  @test t.root.right.right.right.key == 15
  @test t.root.right.right.right.color == RedBlackTree.red


  insert!(t, 6)

  @test t.root.key == 7
  @test t.root.color == RedBlackTree.black

  @test t.root.left.key == 2
  @test t.root.left.color == RedBlackTree.black

  @test t.root.left.left.key == 1
  @test t.root.left.left.color == RedBlackTree.black

  @test t.root.left.right.key == 4
  @test t.root.left.right.color == RedBlackTree.red

  @test t.root.left.right.left.key == 3
  @test t.root.left.right.left.color == RedBlackTree.black

  @test t.root.left.right.right.key == 5
  @test t.root.left.right.right.color == RedBlackTree.black

  @test t.root.left.right.right.right.key == 6
  @test t.root.left.right.right.right.color == RedBlackTree.red

  @test t.root.right.key == 11
  @test t.root.right.color == RedBlackTree.black

  @test t.root.right.left.key == 8
  @test t.root.right.left.color == RedBlackTree.black

  @test t.root.right.right.key == 14
  @test t.root.right.right.color == RedBlackTree.black

  @test t.root.right.right.right.key == 15
  @test t.root.right.right.right.color == RedBlackTree.red
end
