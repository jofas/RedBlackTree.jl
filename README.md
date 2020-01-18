# RedBlackTree.jl

[![Build status](https://travis-ci.org/jofas/RedBlackTree.jl.svg?master)](https://travis-ci.org/jofas/RedBlackTree.jl)


## TODO

* get allocs further down (maybe ```CapacityMatrix{Union{Int64, Nothing}}```)

## Benchmarks

* api from varargs to dot syntax: invariant

* nodes in CapacityVector: approx 80% time, 90% memory improvement

* CVector -> Vector: memory improvement for 1mil, time gain 

* count\_left: slight time improvement for 1mil

* Node homogenous: improvement for insert
