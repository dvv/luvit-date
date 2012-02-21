/*
* date.c: bindings for strptime() and strftime() functions
*
* based on agladysh/lua-getdate
*/

#include <lua.h>
#include <lauxlib.h>

#include <string.h> /* memset */

#define __USE_XOPEN
#include <time.h> /* strptime, strftime */

static void setfield(lua_State *L, const char *key, int value) {
  lua_pushinteger(L, value);
  lua_setfield(L, -2, key);
}

static void setboolfield(lua_State *L, const char *key, int value) {
  if (value < 0)  /* undefined? */
    return;  /* does not set field */
  lua_pushboolean(L, value);
  lua_setfield(L, -2, key);
}

static int l_strptime(lua_State * L) {

  const char *date = luaL_checkstring(L, 1);
  const char *format = luaL_checkstring(L, 2);
  char *stop;
  struct tm tm;

  memset(&tm, 0, sizeof(tm));

  stop = strptime(date, format, &tm);
  /* failed to parse? return nil, false */
  if (!stop) {
    lua_pushnil(L);
    lua_pushboolean(L, 0);
    return 2;
  }

  lua_createtable(L, 0, 10);  /* 10 = number of fields */
  setfield(L, "sec", tm.tm_sec);
  setfield(L, "min", tm.tm_min);
  setfield(L, "hour", tm.tm_hour);
  setfield(L, "day", tm.tm_mday);
  setfield(L, "month", tm.tm_mon + 1);
  setfield(L, "year", tm.tm_year + 1900);
  setfield(L, "wday", tm.tm_wday + 1);
  setfield(L, "yday", tm.tm_yday + 1);
  setboolfield(L, "isdst", tm.tm_isdst);
  setfield(L, "gmtoff", tm.tm_gmtoff);

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
