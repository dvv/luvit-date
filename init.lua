local Date = require('./build/date')
local os = require('os')

local formats = {
  '%Y-%m-%d %H:%M:%S UTC%z',
  '%a, %b %d %y %H:%M:%S GMT%z',
  '%a, %b %d %y %H:%M:%S UTC%z',
  '%a, %b %d %y %H:%M:%S',
  '%a, %b %d %Y %H:%M:%S GMT%z',
  '%a, %b %d %Y %H:%M:%S UTC%z',
  '%a, %b %d %Y %H:%M:%S',
  '%Y-%m-%d %H:%M:%S GMT%z',
  '%Y-%m-%d %H:%M:%S',
  '%Y-%m-%dT%H:%M:%SZ%z',
  '%Y-%m-%dT%H:%M:%S',
  '%b %d %y %H:%M:%S GMT%z',
  '%b %d %y %H:%M:%S UTC%z',
  '%b %d %y %H:%M:%S',
  '%b %d %H:%M:%S GMT%z %Y',
  '%b %d %H:%M:%S UTC%z %Y',
  '%b %d %H:%M:%S %Y',
  '%a %b %d %H:%M:%S GMT%z %Y',
  '%a %b %d %H:%M:%S UTC%z %Y',
  '%a %b %d %H:%M:%S %Y',
}

function Date.parse(x)
  if type(x) == 'table' then return x end
  if type(x) == 'number' then return Date.strptime(tostring(x), '%s') end
  if type(x) ~= 'string' then return end
  local date, remainder
  for i = 1, #formats do
    date, remainder = Date.strptime(x, formats[i])
    if date then
      --if remainder then print('[' .. x:sub(-#remainder) .. ']') end
      if not remainder or x:sub(-#remainder) == remainder then
        return date, formats[i]
      end
    end
  end
end

function Date.format(date, fmt)
  date = Date.parse(date)
  if date then
    return os.date(fmt, os.time(date))
  end
end

function Date.now()
  return os.time()
end

function Date.diff(d1, d2)
  d1 = Date.parse(d1)
  d2 = Date.parse(d2)
  if not d1 or not d2 then return end
  return os.time(d2) - os.time(d1)
end

function Date.add(date, delta)
  date = Date.parse(date)
  if date then
    return Date.parse(os.time(date) + delta)
  end
end

return Date
