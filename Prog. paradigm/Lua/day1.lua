-- Exercise 1
function ends_in_3(num)
  l = string.len(tostring(num))
  return string.sub(num,l,l) == "3"
end

print(ends_in_3(33313))
print(ends_in_3(343534))


-- Exercise 2
function is_prime (n)
  for i=2, n^(1/2) do
    if ( n % i == 0) then
      return false
    end
  end
  return true
end

print(is_prime(10))
print(is_prime(17))

-- Exercise 3
function first_n_primes_ending_in_3 (n)
  primes = {}
  i=0
  while(#primes<n) do
    i=i+1
    if(is_prime(i) and ends_in_3(i)) then
      primes[#primes+1]=i
      print(i)
    end
  end
  return primes
end

first_n_primes_ending_in_3(5)

-- Exercise 4
function for_loop(a,b,f)
  local i=a
  while(i <= b) do
    f(i)
    i=i+1
  end
end

for_loop(5, 100, is_prime)
