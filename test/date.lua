local exports = {}

local Date = require('../')

local d19991231000102 = {
  sec = 2,
  min = 1,
  day = 31,
  gmtoff = 0,
  isdst = false,
  wday = 1,
  yday = 365,
  year = 1999,
  month = 12,
  hour = 0
}

local d19991231000102_o4 = {
  sec = 2,
  min = 1,
  day = 31,
  gmtoff = 14400,
  isdst = false,
  wday = 1,
  yday = 365,
  year = 1999,
  month = 12,
  hour = 0
}

local d19991231000102_m4 = {
  sec = 2,
  min = 1,
  day = 30,
  gmtoff = 0,
  isdst = false,
  wday = 5,
  yday = 364,
  year = 1999,
  month = 12,
  hour = 20
}

local d20120221010203 = {
  sec = 3,
  min = 2,
  day = 21,
  gmtoff = 0,
  isdst = false,
  wday = 3,
  yday = 52,
  year = 2012,
  month = 2,
  hour = 1
}

local d20120221010203_o4 = {
  sec = 3,
  min = 2,
  day = 21,
  gmtoff = -14400,
  isdst = false,
  wday = 3,
  yday = 52,
  year = 2012,
  month = 2,
  hour = 1
}

local d20120221010203_m4 = {
  sec = 3,
  min = 2,
  day = 20,
  gmtoff = 0,
  isdst = false,
  wday = 2,
  yday = 51,
  year = 2012,
  month = 2,
  hour = 21
}

local d20121231235959_o3 = {
  sec = 59,
  min = 59,
  day = 31,
  gmtoff = 10800,
  isdst = false,
  wday = 2,
  yday = 366,
  year = 2012,
  month = 12,
  hour = 23
}

local d20121231235959_p3 = {
  sec = 59,
  min = 59,
  day = 1,
  gmtoff = 0,
  isdst = false,
  wday = 3,
  yday = 1,
  year = 2013,
  month = 1,
  hour = 2
}

exports['ISO date'] = function (test)
  local date, err = Date.strptime(
      '2012-02-21 01:02:03 -0300',
      '%Y-%m-%d %H:%M:%S %z'
    )
  test.equal(date.gmtoff, -10800)
  date.gmtoff = 0
  test.equal(date, d20120221010203)
  date, err = Date.strptime(
      '2012-02-21 01:02:03 GMT+03',
      '%Y-%m-%d %H:%M:%S GMT'
    )
  test.equal(err, '+03')
  test.equal(date, d20120221010203)
  test.equal(Date.parse('2013-12-12T00:00:01').year, 2013)
  test.done()
end

exports['unix date'] = function (test)
  test.equal(Date.parse('Tue Feb 21 10:33:11 2012'), Date.parse(1329820391))
  test.done()
end

exports['RFC6265 date'] = function (test)
  test.equal(Date.parse('Tue, Feb 21 2012 01:02:03 GMT+04'), d20120221010203_m4)
  test.equal(Date.parse('Tue, Feb 21 12 1:2:3'), d20120221010203)
  test.equal(Date.parse('Sun, Dec 31 99 0:1:2 UTC+0400'), d19991231000102_m4)
  test.equal(Date.parse('Sun, Dec 31 99 0:1:2 UTC+0400', true), d19991231000102_o4)
  test.is_nil(Date.parse('Пн, Дек 31 99 0:1:2'))
  test.done()
end

exports['RFC6265 date fallbacks to ISO'] = function (test)
  test.equal(Date.parse('2012-12-31 23:59:59 GMT-0300'), d20121231235959_p3)
  test.equal(Date.parse('2012-12-31 23:59:59 GMT+0300', true), d20121231235959_o3)
  test.done()
end

exports['now() is sane'] = function (test)
  local now = Date.now()
  test.is_number(now)
  test.done()
end

exports['diff() is sane'] = function (test)
  test.equal(Date.diff('2013-12-12T00:00:01', 'Thu, Dec 12 2013 01:00:00'), 3599)
  test.equal(Date.diff('Thu, Dec 12 2013 01:00:00', '2013-12-12T00:00:01'), -3599)
  test.done()
end

exports['add() is sane'] = function (test)
  local date = Date.add('2013-12-12T23:00:01', 100000)
  test.equal(date.year, 2013)
  test.equal(date.month, 12)
  test.equal(date.day, 14)
  test.equal(date.hour, 2)
  test.equal(date.min, 46)
  test.equal(date.sec, 41)
  test.done()
end

exports['format() is sane'] = function (test)
  test.equal(Date.format(d20121231235959_o3, '%Y%m%d%H%M%S%z'), '20121231235959+0000')
  test.equal(Date.format(d19991231000102), 'Fri, 31 Dec 99 00:01:02 GMT')
  -- FIXME: so, 31.12.1999 is Friday or Sunday?!
  --test.equal(Date.parse('Fri, 31 Dec 99 00:01:02 GMT'), d19991231000102)
  test.equal(Date.parse('Sun, 31 Dec 99 00:01:02 GMT'), d19991231000102)
  test.done()
end

return exports
