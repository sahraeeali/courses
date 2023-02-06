#exercise 1
for i in 10:-1:1
    println(i)
end

#exercise 2
mat = [1 2 3; 4 5 6; 7 8 9]
for i in mat
  println(mat[i])
end
# 1 2 3 4 5 6 7 8 9

#exercise 3
using Distributed
trial_count=[1 0 1 1; 1 1 0 1; 1 0 0 1; 0 1 0 1; 1 0 0 0; 0 0 0 0]
println(pmap(x->sum(trial_count[x,:]), 1:6))

#exercise 4
# @parallel has been renamed to @distributed
function fac(n)
    @distributed (*) for i in 1:n
        i
    end
end
println(fac(5))

#exercise 5
function concat(n, m)
  tocat = fill(n,size(m)[1])
  hcat(tocat,m)
end
println(concat(5,[1 2; 3 4]))

#exercise 6
import Base: +
function +(a::String, b::String)
   "$a$b"
end
println("jul" + "ia")
