@testset "test insert" begin

  t = RBTree{Int64}()

  # 1

  insert!(t, 1)

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black


  # 1
  #  \
  #   2

  insert!(t, 2)

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.red


  #   2
  #  / \
  # 1   5

  insert!(t, 5)

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.red

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.black

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   5
  #      \
  #       7

  insert!(t, 7)

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.black

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.black

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   7
  #    / \
  #   5   8

  insert!(t, 8)

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.black

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.red

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.black

  @test t.nodes[5].key == 8
  @test t.nodes[5].color == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   7
  #    / \
  #   5   8
  #        \
  #         11

  insert!(t, 11)

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.black

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.black

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.red

  @test t.nodes[5].key == 8
  @test t.nodes[5].color == RedBlackTree.black

  @test t.nodes[6].key == 11
  @test t.nodes[6].color == RedBlackTree.red

  @test t.root == 2


  #   2
  #  / \
  # 1   7
  #    / \
  #   5   11
  #      /  \
  #     8    14

  insert!(t, 14)

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.black

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.black

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.red

  @test t.nodes[5].key == 8
  @test t.nodes[5].color == RedBlackTree.red

  @test t.nodes[6].key == 11
  @test t.nodes[6].color == RedBlackTree.black

  @test t.nodes[7].key == 14
  @test t.nodes[7].color == RedBlackTree.red

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

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.red

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.black

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.black

  @test t.nodes[5].key == 8
  @test t.nodes[5].color == RedBlackTree.black

  @test t.nodes[6].key == 11
  @test t.nodes[6].color == RedBlackTree.red

  @test t.nodes[7].key == 14
  @test t.nodes[7].color == RedBlackTree.black

  @test t.nodes[8].key == 15
  @test t.nodes[8].color == RedBlackTree.red

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

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.red

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.black

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.black

  @test t.nodes[5].key == 8
  @test t.nodes[5].color == RedBlackTree.black

  @test t.nodes[6].key == 11
  @test t.nodes[6].color == RedBlackTree.red

  @test t.nodes[7].key == 14
  @test t.nodes[7].color == RedBlackTree.black

  @test t.nodes[8].key == 15
  @test t.nodes[8].color == RedBlackTree.red

  @test t.nodes[9].key == 4
  @test t.nodes[9].color == RedBlackTree.red

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

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.red

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.red

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.black

  @test t.nodes[5].key == 8
  @test t.nodes[5].color == RedBlackTree.black

  @test t.nodes[6].key == 11
  @test t.nodes[6].color == RedBlackTree.red

  @test t.nodes[7].key == 14
  @test t.nodes[7].color == RedBlackTree.black

  @test t.nodes[8].key == 15
  @test t.nodes[8].color == RedBlackTree.red

  @test t.nodes[9].key == 4
  @test t.nodes[9].color == RedBlackTree.black

  @test t.nodes[10].key == 3
  @test t.nodes[10].color == RedBlackTree.red

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

  @test t.nodes[1].key == 1
  @test t.nodes[1].color == RedBlackTree.black

  @test t.nodes[2].key == 2
  @test t.nodes[2].color == RedBlackTree.black

  @test t.nodes[3].key == 5
  @test t.nodes[3].color == RedBlackTree.black

  @test t.nodes[4].key == 7
  @test t.nodes[4].color == RedBlackTree.black

  @test t.nodes[5].key == 8
  @test t.nodes[5].color == RedBlackTree.black

  @test t.nodes[6].key == 11
  @test t.nodes[6].color == RedBlackTree.black

  @test t.nodes[7].key == 14
  @test t.nodes[7].color == RedBlackTree.black

  @test t.nodes[8].key == 15
  @test t.nodes[8].color == RedBlackTree.red

  @test t.nodes[9].key == 4
  @test t.nodes[9].color == RedBlackTree.red

  @test t.nodes[10].key == 3
  @test t.nodes[10].color == RedBlackTree.black

  @test t.nodes[11].key == 6
  @test t.nodes[11].color == RedBlackTree.red

  @test t.root == 4
end
