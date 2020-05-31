@testset "test insert" begin

  t = RBTree{Int64}()

  # 1

  insert!(t, 1)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black


  # 1
  #  \
  #   2

  insert!(t, 2)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.red


  #   2
  #  / \
  # 1   5

  insert!(t, 5)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.red

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.black

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   5
  #      \
  #       7

  insert!(t, 7)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.black

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.black

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   7
  #    / \
  #   5   8

  insert!(t, 8)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.black

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.red

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.black

  @test t.key[5] == 8
  @test t.color[5] == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   7
  #    / \
  #   5   8
  #        \
  #         11

  insert!(t, 11)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.black

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.black

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.red

  @test t.key[5] == 8
  @test t.color[5] == RedBlackTree.black

  @test t.key[6] == 11
  @test t.color[6] == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   7
  #    / \
  #   5   11
  #      /  \
  #     8    14

  insert!(t, 14)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.black

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.black

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.red

  @test t.key[5] == 8
  @test t.color[5] == RedBlackTree.red

  @test t.key[6] == 11
  @test t.color[6] == RedBlackTree.black

  @test t.key[7] == 14
  @test t.color[7] == RedBlackTree.red

  @test t.root == 2


  #       7
  #      / \
  #     /   \
  #    /     \
  #   2       11
  #  / \     /  \
  # 1   5   8    14
  #                \
  #                 15

  insert!(t, 15)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.red

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.black

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.black

  @test t.key[5] == 8
  @test t.color[5] == RedBlackTree.black

  @test t.key[6] == 11
  @test t.color[6] == RedBlackTree.red

  @test t.key[7] == 14
  @test t.color[7] == RedBlackTree.black

  @test t.key[8] == 15
  @test t.color[8] == RedBlackTree.red

  @test t.root == 4


  #       7
  #      / \
  #     /   \
  #    /     \
  #   2       11
  #  / \     /  \
  # 1   5   8    14
  #    /           \
  #   4             15

  insert!(t, 4)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.red

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.black

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.black

  @test t.key[5] == 8
  @test t.color[5] == RedBlackTree.black

  @test t.key[6] == 11
  @test t.color[6] == RedBlackTree.red

  @test t.key[7] == 14
  @test t.color[7] == RedBlackTree.black

  @test t.key[8] == 15
  @test t.color[8] == RedBlackTree.red

  @test t.key[9] == 4
  @test t.color[9] == RedBlackTree.red

  @test t.root == 4


  #       7
  #      / \
  #     /   \
  #    /     \
  #   2       11
  #  / \     /  \
  # 1   4   8    14
  #    / \         \
  #   3   5         15

  insert!(t, 3)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.red

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.red

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.black

  @test t.key[5] == 8
  @test t.color[5] == RedBlackTree.black

  @test t.key[6] == 11
  @test t.color[6] == RedBlackTree.red

  @test t.key[7] == 14
  @test t.color[7] == RedBlackTree.black

  @test t.key[8] == 15
  @test t.color[8] == RedBlackTree.red

  @test t.key[9] == 4
  @test t.color[9] == RedBlackTree.black

  @test t.key[10] == 3
  @test t.color[10] == RedBlackTree.red

  @test t.root == 4


  #       7
  #      / \
  #     /   \
  #    /     \
  #   2       11
  #  / \     /  \
  # 1   4   8    14
  #    / \         \
  #   3   5         15
  #        \
  #         6

  insert!(t, 6)

  @test t.key[1] == 1
  @test t.color[1] == RedBlackTree.black

  @test t.key[2] == 2
  @test t.color[2] == RedBlackTree.black

  @test t.key[3] == 5
  @test t.color[3] == RedBlackTree.black

  @test t.key[4] == 7
  @test t.color[4] == RedBlackTree.black

  @test t.key[5] == 8
  @test t.color[5] == RedBlackTree.black

  @test t.key[6] == 11
  @test t.color[6] == RedBlackTree.black

  @test t.key[7] == 14
  @test t.color[7] == RedBlackTree.black

  @test t.key[8] == 15
  @test t.color[8] == RedBlackTree.red

  @test t.key[9] == 4
  @test t.color[9] == RedBlackTree.red

  @test t.key[10] == 3
  @test t.color[10] == RedBlackTree.black

  @test t.key[11] == 6
  @test t.color[11] == RedBlackTree.red

  @test t.root == 4
end
