#Julia version 1.6.7

#exercise 1
println(typeof(+))
println(typeof(Int64))
println(typeof(Symbol))
println(typeof(-))

#exercise 2
mydict = Dict{Symbol, Float64}(:a => 1, :b => 2, :c => 3)
mydict[:thisis] = :notanumber


#exercise 3
a = fill(0,(5,5,5))
for i in 1:5
  a[:,:,i].=i
end
println(a)

#exercise 4
a=fill(1.3,(3,3))
sin(a)
b=fill("hello",(3,3))
round(b)

#exercise 5
mat = [1 2; 3 4] #invertable matrix
inv_mat = inv(mat)
println(mat*inv_mat)

#exercise 6
dict1 = Dict(:a => 1, :b => 2, :c => 3)
dict2 = Dict(:d => 4, :e => 5, :f => 6)
println(merge(dict1,dict2))

#exercise 7
#'sort' will return a sorted copy of your array and 'sort!' will sort it in place.
a = [2, 3, 1]
sort(a)
println(a)
sort!(a)
println(a)
