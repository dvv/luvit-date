local Date = require('./build/date')
local os = require('os')

local formats = {
  '%Y-%m-%d %H:%M:%S',
  '%a %d %b %y %H:%M:%S',
  '%a %b %d %y %H:%M:%S',
  '%a %d %b %Y %H:%M:%S',
  '%a %b %d %Y %H:%M:%S',
  '%Y-%m-%dT%H:%M:%SZ%z',
  '%Y-%m-%dT%H:%M:%S',
  '%b %d %y %H:%M:%S',
  '%b %d %H:%M:%S %Y',
  '%a %b %d %H:%M:%S %Y',
  -- what else we missed?
}

function Date.parse(x, dont_offset)
  if type(x) == 'table' then return x end
  if type(x) == 'number' then return Date.strptime(tostring(x), '%s') end
  if type(x) ~= 'string' then return end
  x = x:gsub(',', '')
  local date, remainder
  for i = 1, #formats do
    date, remainder = Date.strptime(x, formats[i])
    if date then
      -- process remainder of form GMT+-hhmm, UTC+-hhmm
      if remainder then
        -- compose dummy date of simple format with the unparsed remainder
        remainder = '20120101000000' .. remainder:gsub('GMT', 'UTC')
        -- parse dummy date, to extract UTC offset
        local offset = Date.strptime(remainder, '%Y%m%d%H%M%S UTC%z')
        --p(remainder, offset)
        -- compensate the date for GMT offset, unless prohibited
        --[[if offset then
          if not dont_offset then
            date = Date.parse(os.time(date) - offset.gmtoff)
          -- or just fill date.gmtoff field
          else
            date.gmtoff = offset.gmtoff
          end
        end]]--
      end
      return date
    end
  end
end

function Date.format(date, fmt)
  date = Date.parse(date)
  if date then
    return os.date(fmt or '%a, %d %b %y %H:%M:%S GMT', os.time(date))
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
