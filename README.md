Date
=====

A collection of date manipulation tools.

Usage
-----

```lua

local Date = require('date')

-- parse
p(Date.parse('Tue, Feb 21 2012 01:02:03 GTM+0300'))

-- format
print(Date.format(Date.now(), '%Y-%m-%d %H:%M:%S'))

-- difference, in seconds
print(Date.diff('Tue, Feb 21 2012 01:02:03 GTM+0300', '2013-01-01 00:00:00'))

-- date arithmetics
p(Date.add('Tue, Feb 21 2012 01:02:03 GTM+0300', 120000))

```

TODO:
-----

Elaborate UTC offsets

License
-----

[MIT](luvit-date/license.txt)
