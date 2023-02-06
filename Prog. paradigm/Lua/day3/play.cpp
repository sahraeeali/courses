extern "C"
{
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}

#include "RtMidi.h"
static RtMidiOut midi;

int midi_send(lua_State* L)
{
    double volume  = lua_tonumber(L, -4);
    double status = lua_tonumber(L, -3);
    double data1  = lua_tonumber(L, -2);
    double data2  = lua_tonumber(L, -1);

    // ...Added...
    std::vector<unsigned char> volmsg(3);
    volmsg[0] = static_cast<unsigned char>(176); // cf: http://www.midi.org/techspecs/midimessages.php
    volmsg[1] = static_cast<unsigned char>(7);
    volmsg[2] = static_cast<unsigned char>(volume);

    midi.sendMessage(&volmsg);

    std::vector<unsigned char> message(3);
    message[0] = static_cast<unsigned char>(status);
    message[1] = static_cast<unsigned char>(data1);
    message[2] = static_cast<unsigned char>(data2);

    midi.sendMessage(&message);

    return 0;
}

// ...Added...
void err_handle(lua_State *state) {
  if (!lua_isstring(state, lua_gettop(state)))
  std::cerr << "Error: Undefined error. What the heck?";

  std::string str = lua_tostring(state, lua_gettop(state));
  lua_pop(state, 1);

  std::cerr << str;
  std::cerr << "\n";
}

int main(int argc, const char* argv[])
{
    if (argc < 1) { return -1; }

    unsigned int ports = midi.getPortCount();
    if (ports < 1) { return -1; }
    midi.openPort(0);

    lua_State* L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushcfunction(L, midi_send);
    lua_setglobal(L, "midi_send");
    // ...Added...
    int err = luaL_dofile(L, argv[1]);
    if(err){
      std::cerr << "Error: reading file is not possible\n\n";
      err_handle(L);
      return -3;
    }
    else {
      luaL_dostring(L,"song.go()");
    }
    lua_close(L);
    return 0;
}
