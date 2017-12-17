mutable struct Bits{N}
  offset::Int
  state
end

const states = WeakKeyDict()

function Bits{N}() where N
  b = Bits{N}(0, State(N))
  states[b.state] = WeakKeyDict(b=>nothing)
  return b
end

function combine(a::State, b::State)
  a === b && return
  of = nbits(a)
  a.ψ = a.ψ ⊗ b.ψ
  for buf in keys(states[b])
    buf.state = a
    buf.offset += of
  end
  return a
end

combine(b::Bits) = b.state
combine(bs::Bits...) = reduce(combine, map(x -> x.state, bs))

bitindices(b::Bits{N}) where N = ntuple(i -> b.offset+i, Val{N})

tcat(x::Tuple) = x
tcat(x::Tuple, y::Tuple, ys::Tuple...) = tcat((x..., y...), ys...)

function apply!(U, bs::Bits...)
  s = combine(bs...)
  is = tcat(bitindices.(bs)...)
  apply!(U, s, is...)
  return
end