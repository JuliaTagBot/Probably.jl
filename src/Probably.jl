module Probably

using Base.Iterators: filter, take, repeated

export State, QBool, epr, measure, hadamard, not, cnot, classical

a ⊗ b = kron(a, b)

include("operators.jl")
include("state.jl")
include("buffer.jl")
include("data.jl")

end # module
