-- Exercise 1
function concatenate (a1, a2)
  for i=1,#a2 do
    a1[#a1+i] = a2[i]
  end
  return a1
end

-- Exercise 2
local mt = {
  __index = strict_read,
  __newindex = strict_write
}

local _private = {}

function strict_read(table, key)
  if _private[key] then
    return _private[key]
  else
    error("Invalid Key: " .. key)
  end
end

function strict_write(table, key, value)
  if _private[key] and value ~= nil then
    error("Duplicate Key: " .. key)
  else
    _private[key] = value
  end
end

treasure = {}
setmetatable(treasure, mt)

-- Exercise 3
function newindex (t, k, v)
  rawset(t,k,v)
  if type(v) == "table" then
    setmetatable(t[k]
                , { add = concatenate
                  , _tostring = dumper.write
                  }
                )
  end
end

setmetatable(_G,{newindex=newindex})


--Exercise 4
Queue = { q = {} }

function Queue:new()
  local obj = {}
  setmetatable(obj, {__index = Queue})
  return obj
end

function Queue:add(item)
  if item == nil then
    error "Can't add nil item to queue"
  end
  self.q[#self.q+1] = item
end

function Queue:remove()
  if #self.q<1 then
    return nil
  else
    fst = self.q[1]
    for i=1,#self.q - 1 do
      self.q[i] = self.q[i+1]
    end
    self.q[#self.q] = nil
    return fst
  end
end

q = Queue.new()
q:add(10)
q:add(20)
q:remove()
