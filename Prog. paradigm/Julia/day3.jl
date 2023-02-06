#exercise 1
macro backwards(b)
 quote
   map(eval,reverse($b.args))
   return
 end
end

@backwards :(begin
   println("The first print.")
   println("The second print.")
   println("The third print.")
end)


#exercise 2
#using Pkg
#Pkg.add("Images")
#Pkg.add("TestImages")
#Pkg.add("ImageView")
#Pkg.add("FFTW")
#Pkg.add("ImageCore")

using TestImages, ImageView, FFTW, ImageCore

function blockdct6(img)
  pixels = convert(Array{Float32}, img)
  y,x = size(pixels)

  outx = floor(Int64, x/8)
  outy = floor(Int64, y/8)

  bx = 1:8:outx*8
  by = 1:8:outy*8

  mask = zeros(8,8)
  mask[1:3,1:3] = [1 1 1; 1 1 0; 1 0 1]  ## keep stuff marked 1, drop stuff that is 0

  freqs = Array{Float32, 2}(undef,outy*8,outx*8)

  for i=bx, j=by
    freqs[j:j+7, i:i+7] = dct(pixels[j:j+7, i:i+7])
    freqs[j:j+7, i:i+7] .*= mask
  end

  #map(scaleupHighNumber, freqs)
  #(freqs .+ rand(size(freqs))) .* rand(size(freqs))
  freqs * rand(size(freqs))
end

# function scaleupHighNumber(n)
#   if n > 3
#     n * 2
#   else
#     n
#   end
# end

function blockidct(freqs)
    y,x = size(freqs)
    bx = 1:8:x
    by = 1:8:y
    pixels = Array{Float32, 2}(undef,y,x)
    for i=bx, j=by
      pixels[j:j+7, i:i+7] = idct(freqs[j:j+7, i:i+7])
    end
    colorview(Gray, pixels)
end

img = testimage("cameraman")
freqs = blockdct6(img)
pixels = blockidct(freqs)
imshow(pixels) #"view" is changed to "imshow"




#exercise 3
using TestImages, ImageView, FFTW, ImageCore

function make_mask(width,n)
  row_max = n
  arr=zeros(width,width)
  for i=1:row_max
     for j=1:row_max
        if(j<n-(i+1))
          arr[i,j]=1
        end
     end
  end
  arr
end

function blockdct6(img, n)
  pixels = convert(Array{Float32}, img)
  y,x = size(pixels)

  outx = floor(Int64, x/8)
  outy = floor(Int64, y/8)

  bx = 1:8:outx*8
  by = 1:8:outy*8

  mask = make_mask(8, n)

  freqs = Array{Float32, 2}(undef,outy*8,outx*8)

  for i=bx, j=by
    freqs[j:j+7, i:i+7] = dct(pixels[j:j+7, i:i+7])
    freqs[j:j+7, i:i+7] .*= mask
  end

  freqs * rand(size(freqs))
end

function blockidct(freqs)
    y,x = size(freqs)
    bx = 1:8:x
    by = 1:8:y
    pixels = Array{Float32, 2}(undef,y,x)
    for i=bx, j=by
      pixels[j:j+7, i:i+7] = idct(freqs[j:j+7, i:i+7])
    end
    colorview(Gray, pixels)
end

img = testimage("cameraman")
freqs = blockdct6(img, 4)
pixels = blockidct(freqs)
imshow(pixels) #"view" is changed to "imshow"


#exercise 4
using TestImages, ImageView, FFTW, ImageCore

function make_mask(width,n)
  row_max = n
  arr=zeros(width,width)
  for i=1:row_max
     for j=1:row_max
        if(j<n-(i+1))
          arr[i,j]=1
        end
     end
  end
  arr
end

function blockdct6(img, n)
  pixels = convert(Array{Float32}, img)
  y,x = size(pixels)

  outx = floor(Int64, x/8)
  outy = floor(Int64, y/8)

  bx = 1:8:outx*8
  by = 1:8:outy*8

  mask = make_mask(8, n)

  freqs = Array{Float32, 2}(undef,outy*8,outx*8)

  for i=bx, j=by
    freqs[j:j+7, i:i+7] = dct(pixels[j:j+7, i:i+7])
    freqs[j:j+7, i:i+7] .*= mask
  end

  freqs
end

function blockidct(freqs)
    y,x = size(freqs)
    bx = 1:8:x
    by = 1:8:y
    pixels = Array{Float32, 2}(undef,y,x)
    for i=bx, j=by
      pixels[j:j+7, i:i+7] = idct(freqs[j:j+7, i:i+7])
    end
    colorview(Gray, pixels)
end

function smaller_blockdct(img,n)
  sparse(blockdct(img,n))
end

function smaller_blockidct(freqs,n)
  blockidct(full(freqs))
end

img = testimage("cameraman")
freqs = blockdct6(img, 6)
pixels = blockidct(freqs)
imshow(pixels)

#exercise 5
using TestImages, ImageView, FFTW, ImageCore

function make_mask(width,n)
  row_max = n
  arr=zeros(width,width)
  for i=1:row_max
     for j=1:row_max
        if(j<n-(i+1))
          arr[i,j]=1
        end
     end
  end
  arr
end

function blockdct(img, n, bs)
    pixels = convert(Array{Float32}, img)
    y,x = size(pixels)

    outx = floor(Int64, x/8)
    outy = floor(Int64, y/8)

    bx = 1:bs:outx*bs
    by = 1:bs:outy*bs

    mask = make_mask(bs,n)

    freqs = Array{Float32, 2}(undef,outy*bs,outx*bs)

    for i=bx, j=by
      freqs[j:j+bs-1, i:i+bs-1] = dct(pixels[j:j+bs-1, i:i+bs-1])
      freqs[j:j+bs-1, i:i+bs-1] .*= mask
    end

    freqs
end

function blockidct(freqs,bs)
    y,x = size(freqs)
    bx = 1:bs:x
    by = 1:bs:y
    pixels = Array{Float32, 2}(undef,y,x)
    for i=bx, j=by
      pixels[j:j+bs-1, i:i+bs-1] = idct(freqs[j:j+bs-1, i:i+bs-1])
    end
    colorview(Gray, pixels)
end

img = testimage("cameraman")
freqs = blockdct6(img, 6, 8)
pixels = blockidct(freqs, 8)
imshow(pixels) #"view" is changed to "imshow"
