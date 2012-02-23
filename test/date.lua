local exports = {}

local os = require('os')
local Date = require('../')

exports['strptime is sane'] = function (test)
  --
  local ts = os.time()
  local s = os.date('%c %Z', ts)
  test.equal(os.time(Date.strptime(s, '%c %Z')), ts)
  --
  ts = os.time()
  s = os.date('%c %Z', ts)
  local expected = os.date('*t', ts)
  test.equal(Date.strptime(s, '%c %Z'), expected)
  --
  ts = os.time()
  s = os.date('%c', ts)
  test.equal(os.time(Date.strptime(s, '%c')), ts)
  --
  ts = os.time()
  s = os.date('%c', ts)
  expected = os.date('*t', ts)
  test.equal(Date.strptime(s, '%c'), expected)
  -- strptime reports same what os.date() reports
  test.equal(os.date('*t', 1329820391), Date.strptime('1329820391', '%s'))
  test.done()
end

exports['ISO date'] = function (test)
  local date, err = Date.strptime(
      '2012-02-21 01:02:03 -0300',
      '%Y-%m-%d %H:%M:%S %z'
    )
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
  test.equal(Date.parse('Tue Feb 21 14:33:11 2012'), Date.parse(1329820391))
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
  date = os.date('*t', date)
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
