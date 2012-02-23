/*
* date.c: bindings for strptime() and strftime() functions
*
* based on agladysh/lua-getdate
*/

#include <lua.h>
#include <lauxlib.h>

#include <string.h> /* memset */

/* N.B. inclusion of strptime depends on this define */
#define __USE_XOPEN
#include <time.h> /* strptime */

static int l_strptime(lua_State * L) {

  const char *date = luaL_checkstring(L, 1);
  const char *format = luaL_checkstring(L, 2);
  char *stop;
  struct tm tm;
  time_t time;

  memset(&tm, 0, sizeof(tm));

  stop = strptime(date, format, &tm);
  /* failed to parse? return nil, false */
  if (!stop) {
    lua_pushnil(L);
    lua_pushboolean(L, 0);
    return 2;
  }

  /* convert to calendar date */
  time = mktime(&tm);

  /* compensate for GMT offset */
  time += tm.tm_gmtoff;

  lua_pushinteger(L, time);

  /* if not parsed whole format, return the remainder as well */
  if (*stop) {
    lua_pushstring(L, stop);
    return 2;
  }

  return 1;
}

/* Lua module API */
static const struct luaL_reg exports[] = {
  { "strptime", l_strptime },
  { NULL, NULL }
};

LUALIB_API int luaopen_date(lua_State * L) {
  lua_newtable(L);
  luaL_register(L, NULL, exports);
  return 1;
}
