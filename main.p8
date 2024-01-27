pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- comment
#include _game.lua
#include gram.lua
#include input.lua
#include baddies.lua
#include player.lua

_chars = {}
_dialog = {}

STATE_EXPLORE = "explore"
STATE_SHOWTIME = "showtime"
STATE_GAMEOVER = "gameover"
SHOWTIME_TIMER = 60
_current_state = STATE_EXPLORE
_showtime_current_timer=SHOWTIME_TIMER
_score = 0

_last_t = 0

function _init()
  printh("_init")
  change_state(STATE_EXPLORE)
  _last_t = time()
  _chars = split("웃,♥,⧗,ˇ,▤,✽")
  -- _chars = shuffle(_chars)
  input:init(_chars)

  -- init grammar
  gs[1]:init(_chars)
  gs[1]:debug()
  -- Make some strings!
  for i=1,6 do 
    local d = gs[1]:gen(1 + flr(rnd(3)))
    while elem(d, _dialog) do
      d = gs[1]:gen(1 + flr(rnd(3)))
    end
    printh("Added: "..d)
    _dialog[i] = d
  end

  -- give baddies some dialog
  baddie_mngr:init()
  baddie_mngr:add(32, 32, false, _dialog[1])
  baddie_mngr:add(64, 64, true, _dialog[2])
  baddie_mngr:add(96, 40, true, _dialog[3])
  baddie_mngr:add(15, 70, false, _dialog[4])
  baddie_mngr:add(98, 85, false, _dialog[5])

  -- player
  player:init()
end

function _update60()
  local now = time()
  local dt = now - _last_t
  _last_t = now
  if _current_state == STATE_EXPLORE then
    _explore_update(dt)
  else 
    _showtime_update(dt)
  end
end

function _draw()
  if _current_state == STATE_EXPLORE then
    _explore_draw(dt)
  elseif _current_state == STATE_GAMEOVER then
    _gameover_draw(dt)
  else 
    _showtime_draw(dt)
  end
end


__gfx__
00000000bb8888bbbb8888bbbb8888bbbb8888bb0000000000000000bbbebebbbbbbbbbb00000000000000000000000000000000000000000000000000000000
00000000b888888bb888888bb888888bb888888b0000000000000000bbeeeebbbbbebebe00000000000000000000000000000000000000000000000000000000
00700700888c9c9b888c9c9b888c9c9b888c9c9b0000000000000000bee8e8bbebeeeeeb00000000000000000000000000000000000000000000000000000000
00077000889999bb889999bb889999bb889999bb0000000000000000ebeeeeebbee8e8bb00000000000000000000000000000000000000000000000000000000
00077000b666666bb666666bb666666bb666666b0000000000000000bb8888bbbbeeeebb00000000000000000000000000000000000000000000000000000000
00700700bb6666bbbb6666bbbb6666bbbb6666bb0000000000000000bbebbebbbb8888bb00000000000000000000000000000000000000000000000000000000
00000000bb6666bbbb6666bbbb6666bbbb6666bb0000000000000000bbebbebbbbebbebb00000000000000000000000000000000000000000000000000000000
00000000b6bbbb6bb6bbbb6bb6bbbb6bb6bbbb6b0000000000000000bbeebeebbbebbebb00000000000000000000000000000000000000000000000000000000
bbb77bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb7887bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b788887b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
78888887000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77788777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb7887bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb7887bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb7777bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb8888bbbbbbbbbb00000000bb8888bbbb8888bb00000000bb8888bbbb8888bb0000000000000000000000000000000000000000000000000000000000000000
b888888bbb8888bb00000000b888888bb888888b00000000b888888bb888888b0000000000000000000000000000000000000000000000000000000000000000
b88c9c9bb888888b00000000b988889bb988889b00000000b9c99c9bb9c99c9b0000000000000000000000000000000000000000000000000000000000000000
889999bbb88c9c9b00000000bb8888bbbb8888bb00000000b89999bbbb99998b0000000000000000000000000000000000000000000000000000000000000000
8b66666bb89999bb00000000bb66866bb66866bb00000000b66666bbbb66666b0000000000000000000000000000000000000000000000000000000000000000
b6666cbb8b6666bb00000000b66668bbbb86666b00000000bb66666bb66666bb0000000000000000000000000000000000000000000000000000000000000000
bbcccbcbbbccccbb00000000bbccccbbbbccccbb00000000bbccc5bbbb5cccbb0000000000000000000000000000000000000000000000000000000000000000
bcbbbbbbbbcbcbbb00000000bbcbbbbbbbbbbcbb00000000bbcbbbbbbbbbbcbb0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb555600000000000000000000000000000000000000000000
bbbbbb8888888bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb556600000000660000000000000000000000000000000000
bbbb8888888888bbb88bbbbbbbbbbbbbbbbbbbbbbbb88bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb888566aa0000000650000000000000000000000000000000000
bbb88888bbb88888b88bbbbbbbbbbbbbbbbbbbbbbbb88bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb88866aaaaaa0000005000000000000000000000000000000000
bb8888bbbbbbb888888bbbbbbbbbbbbbbbbbbbbbbbb888bbb88bbbbbbbbbbbbbbbbbbbbbbbbb888b00aaaaaa0000005000000000000000000000000000000000
bb888bbbbbbbbb8888bbbbbbbbbbbbbbbbbbbbbbbbb88888b88bbbbbbbbbbbbbbbbbbbbbbbbb888b000aaaaa0000005000000000000000000000000000000000
bb888bbbbbbbbbbb88bbbbbbbbbbbbbbbbbbbbb888888888bbbbbbbbbbbbbbbb88888bbbbbbb88bb0000aaaa0000005000000000000000000000000000000000
bbb888bbbbbbbbbb88bbbbbbbbbbbbbbbbbbbbb8888888bbbbbbb88bbbbbbbbb888888bbbbbb88bb0000aaaa0000055500000000000000000000000000000000
bbb8888bbbbbbbbb88bbbbbbbbbbbbbbbbbbbbbbbbbb88bbb88bb8888888888b88b888bbbbb888bb000000000000000000000000000000000000000000000000
bbbb888888bbbbbb888888bbbb888bbbbbbbbbbbbbbb88bbb88bb8888888888888bb88bbbbb88bbb000000000000000000000000000000000000000000000000
bbbbbb8888888bbb8888888bb888888b88bbbbbb88bb88bbb88bb88888888888888888bbbbb88bbb000000000000000000000000000000000000000000000000
bbbbbbbbb8888888b88b888bb888888888b888b888bb88bbb888b888b888bb88888888bbbb888bbb000000000000000000000000000000000000000000000000
bb888bbbbbb88888b88bb88b888bb888888888888bbb88bbb888b88bb888bb8888bbbb888b888bbb000000000000000000000000000000000000000000000000
bb8888bbbbbbbb88b88bb88b888b888b88888888bbb888bbbb88b88bb88bbb8888bb88888bbbbbbb000000000000000000000000000000000000000000000000
bbb888888bbb8888b88bb88bb888888bb8888888bbb888bbbb88b88bbbbbbb8888888888bb888bbb000000000000000000000000000000000000000000000000
bbbb888888888888b88bb88bbb8888bbb88b888bbbbbbbbbbb88bbbbbbbbbb88888888bbbb888bbb000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54454500005454455555555500000000555555555555555554445400004544450000000000000000000000000000000000000000000000000000000000000000
54445400004544454444444400000000544444444444444554454500005454450000000000000000000000000000000000000000000000000000000000000000
54454500005454454444444454545454544444444444444554445454454544450000000000000000000000000000000000000000000000000000000000000000
54445400004544455454545445454545544454544545444554454545545454450000000000000000000000000000000000000000000000000000000000000000
54454500005454454545454554545454544545455454544554445454454544450000000000000000000000000000000000000000000000000000000000000000
54445400004544455454545444444444544454544545444554444444444444450000000000000000000000000000000000000000000000000000000000000000
54454500005454450000000044444444544545000054544554444444444444450000000000000000000000000000000000000000000000000000000000000000
54445400004544450000000055555555544454000045444555555555555555550000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
8482828282828282828282828285000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8088888888888888888888888881000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8683838383838383838383838387000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0089898989898989000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
