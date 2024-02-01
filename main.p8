pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- comment
#include _game.lua
#include baddies.lua
#include fleas.lua
#include fx.lua
#include gram.lua
#include input.lua
#include player.lua
#include timers.lua


_chars = {}
_dialog = {}

STATE_EXPLORE = "explore"
STATE_SHOWTIME = "showtime"
STATE_GAMEOVER = "gameover"
STATE_TITLE = "title"
SHOWTIME_TIMER = 60
_current_state = STATE_EXPLORE
_showtime_current_timer=SHOWTIME_TIMER
_score = 0

_last_t = 0

function _init()
  printh("_init")
  change_state(STATE_TITLE)
end

function __init()
  _showtime_current_timer=SHOWTIME_TIMER
  _showtime_remaining_timer=SHOWTIME_TIMER
  _last_t = time()
  _chars = split("웃,♥,⧗,ˇ,▤,✽")
  _altchars = split("웃,♥,⧗,ˇ,▤,✽")
  _chars = shuffle(_chars)
  for k, v in pairs(_chars) do 
    printh("Shuffed "..k..": "..v)
  end
  -- _chars = shuffle(_chars)
  input:init(_altchars)

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
  elseif _current_state == STATE_TITLE then
    _title_update(dt)
  elseif _current_state == STATE_GAMEOVER then
    _gameover_update(dt)
  else 
    _showtime_update(dt)
  end
end

function _draw()
  if _current_state == STATE_EXPLORE then
    _explore_draw(dt)
  elseif _current_state == STATE_TITLE then
    _title_draw(dt)
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
bbbb88eeeeeeeebbb8ebbbbbbbbbbbbbbbbbbbbbbbb8ebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8eb566aa0000000650000000000000000000000000000000000
bbb8eeeebbbeeeeeb8ebbbbbbbbbbbbbbbbbbbbbbbb8ebbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8eb66aaaaaa0000005000000000000000000000000000000000
bb8eeebbbbbbbeee8eebbbbbbbbbbbbbbbbbbbbbbbb8eebbb8ebbbbbbbbbbbbbbbbbbbbbbbbb8eeb00aaaaaa0000005000000000000000000000000000000000
bb8eebbbbbbbbbee8ebbbbbbbbbbbbbbbbbbbbbbbbb8eeeeb8ebbbbbbbbbbbbbbbbbbbbbbbbb8eeb000aaaaa0000005000000000000000000000000000000000
bb8eebbbbbbbbbbb8ebbbbbbbbbbbbbbbbbbbbb88888eeeebbbbbbbbbbbbbbbb88888bbbbbbb8ebb0000aaaa0000005000000000000000000000000000000000
bbb8eebbbbbbbbbb8ebbbbbbbbbbbbbbbbbbbbb8eeeeeebbbbbbb8ebbbbbbbbb8eeee8bbbbbb8ebb0000aaaa0000055500000000000000000000000000000000
bbb8eeebbbbbbbbb8ebbbbbbbbbbbbbbbbbbbbbbbbbb8ebbb8ebb8e88888888beebeeebbbbb8eebb000000000000000000000000000000000000000000000000
bbbb88eeeebbbbbb8e8888bbbb8eebbbbbbbbbbbbbbb8ebbb8ebb8eeeeeeeee8eebb8ebbbbb8ebbb000000050000000000000000000000000000000000000000
bbbbbb888eeeebbb8eeeee8bb8eeeeeb8ebbbbbb8ebb8ebbb8ebb8eeeeeeeeee8e888ebbbbb8ebbb000000000000000000000000000000000000000000000000
bbbbbbbbb88eeeeeb8ebeeebb8eeeeee8eb8eeb8eebb8ebbb8eeb8eeb8eebb8e8eeeeebbbb8eebbb000000050000000000000000000000000000000000000000
bb8eebbbbbb888eeb8ebb8eb8eebb8ee8e8eee8eebbb8ebbb8eeb8ebb8eebb8e8ebbbb888b8eebbb000000050000000000000000000000000000000000000000
bb8eeebbbbbbbb8eb8ebb8eb8eeb8eeb8eeeeeeebbb88ebbbb8eb8ebb8ebbb8e8ebb888eebbbbbbb000000050000000000000000000000000000000000000000
bbb8eeeeebbb88eeb8ebb8ebb8eeeeebb8ee8eeebbb8eebbbb8eb8ebbbbbbb8e8e888eeebb8eebbb000000000000000000000000000000000000000000000000
bbbb8eeeeeeeeeeeb8ebb8ebbb8eeebbb8eb8eebbbbbbbbbbb8ebbbbbbbbbb8e8eeeeebbbb8eebbb050555050000000000000000000000000000000000000000
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
65550500005055566666666600000000666666666666666665505000000505560000000000000000000000000000000000000000000000000000000000000000
65505000000505565555555500000000655555555555555665555500005555560000000000000000000000000000000000000000000000000000000000000000
65550500005055565555555550505050655555555555555665505050050505560000000000000000000000000000000000000000000000000000000000000000
65555000000555565550555005050505655050500505055665555555555555560000000000000000000000000000000000000000000000000000000000000000
65550500005055560505050555505550655555555555555665505050050505560000000000000000000000000000000000000000000000000000000000000000
65505000000505565050505055555555655050500505055665555555555555560000000000000000000000000000000000000000000000000000000000000000
65550500005055560000000055555555655555000055555665555555555555560000000000000000000000000000000000000000000000000000000000000000
65555000000555560000000066666666655050000005055666666666666666660000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06555555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65550000000000006655555000066555000065500006555000065555500055555000655550000655555000000000000000000000000000000000000000000000
65555555555550006505555500655555500655550065555500605555550655555506555555506555555000000000000000000000000000000000000000000000
0655555555555500650000650065c115500655000065000000650000650650006506500006500006500000000000000000000000000000000000000000000000
00000000005555006500006500651115500655000065000000650000650650006506500065000006500000000000000000000000000000000000000000000000
00000000000055006555555500651115500655000065550000655555550650006506506655000006500000000000000000000000000000000000000000000000
00000000000055006555555000655555500655000065550000655555500650006506505500000006500000000000000000000000000000000000000000000000
00000000000055006500000000655555500655000065550000650000000650005506500055000006500000000000000000000000000000000000000000000000
00655555555555006500000000650005500655000065000000650000000650005506500055000006500000000000000000000000000000000000000000000000
06555555555555006500000000650005500655550060555500650000000655555506500055000006500000000000000000000000000000000000000000000000
65555555555550005000088888050005000065550065555500500000000055555006500055000006500000000000000000000000000000000000000000000000
0000000000000008888888eee8888800888000000000000000000888880000000000000000000000000000000000000000000000000000000000000000000000
0000000000008888eeeeeeeeeeeee8888e8008888888880888888eeee88000000000000000000000000000000000000000000000000000000000000000000000
0000000000888eeeeeeeeee7eeeeeeeeeee888eeeeeee888eeee7777ee8800000000000000000000000000000000000000000000000000000000000000000000
00000000008eeeee7777eeeeeee777eee77eeee77eeeeeeeeee77eeeeee880000000000000000000000000000000000000000000000000000000000000000000
00000000088eeee77ee77ee7ee7ee77e7ee7eee7eee77777eee7eeeeeeee80000000000000000000000000000000000000000000000000000000000000000000
0000000008eeeee7eeee7e77ee7eee7e7eee7e77ee77eee77ee7777eeeee88000000000000000000000000000000000000000000000000000000000000000000
0000000008eeeee7eee77e7eee7ee77e7ee77e7eeee777777eeeeee7eeeee8000000000000000000000000000000000000000000000000000000000000000000
0000000088eeeeee7777ee77ee7777eee77e7e7eeee77eeeeeeee777eeeee8000000000000000000000000000000000000000000000000000000000000000000
0000000088eee7eeeee7eeeeeeeeee7eeeee7e77eeee777777e777eeeeee88000000000000000000000000000000000000000000000000000000000000000000
00000000088eee77ee77eeeee77ee77eeeee7ee7eeeeeeeeeeeeeeeeee8880000000000000000000000000000000000000000000000000000000000000000000
000000000088eee7777eeeeeee7777ee7777eee77ee8888eeee8888ee88000000000000000000000000000000000000000000000000000000000000000000000
0000000000088e8888eeee8888eeee88888888eee888008ee8880088880000000000000000000000000000000000000000000000000000000000000000000000
00000000000088800888888008888880000008888800008880000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
8482828282828282828282828285000000000000c0c1c2c3c4c5c6c7c8c9cacb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5a5a5a5a5a5a5a5a5a5a5a81000000000000d0d1d2d3d4d5d6d7d8d9dadb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5b5a5a5a5a5a5a5b5a5a5a81000000000000e0e1e2e3e4e5e6e7e8e9eaeb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5a5a5b5a5b5a5a5a5a5b5a81000000000000f0f1f2f3f4f5f6f7f8f9fafb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5a5a5a5a5a5a5a5a5b5a5a81000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5a5a5b5a5b5a5a5a5a5a5b81000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5b5a5a5a5a5a5a5b5a5a5b81000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5b5a5b5a5a5b5a5a5b5a5a81000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5a5a5a5a5a5b5a5a5a5a5a81000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
805a5a5a5a5b5a5a5a5a5a5a5a81000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8683838383838383838383838387000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0089898989898989000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
011000000355300500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
011000000f65500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605
011000003f61500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605006050060500605
21100001005520cd02005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502005020050200502
011000000205500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
21100002005540cd55005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01130000025530b80004800048003f61510800108001e800025531250000300128003f615128000080010800025531e8003c800248003f6150e8001080012800025531080000800008003f615158000080000800
0112002010800006000fa00006001080000605006050060510800006000fa00006001080000605006050060510800006000fa0000600108000060500605006051080000600006000060010800006050060500605
0112002010800006000fa0000600108000fa00006000fa0010800108001080000600108000fa00006050060510800006000fa001ba0010800006000ca000060510800006001ba00108001080010a000060500605
0112002021b0015b0010b0017b0012c001ac0010c0021c0023b0017b0000b0012b0010c0012c0000b0423b0021b0015b0012c0000b0012c000ec0010c0012c0010b001cb001cb0000b0012c0015c0017c0000b04
0112002017c000ec001cb0012c0017c001eb0010c0012b0017c000ec0021b0012b0017b000fc0015c0015c0017c000ec0010b0012c0015c0017c000eb0010c0012c0015b0017c0015c0015b0017c0012b0017c00
4913002002055040350000006045090350b055000000b0000b0450e055000050000009035060450203500000020550b0450000000000090350304506055000000605510045000000000009035170450203510055
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020c150d7300e7300f730127301473016720197101c7101f75025700227003370006730097300c7301073014730197201e7001f700217001a7000c7000f70013700197001f7002470025700147001170010700
000300002574022730207201c7001370017700197001c7001f700257002270033700067001a740177301572014700197001e7001f700217001a7000f7000b70007700197001f7000b70009700057000370010700
00020000163301633013330123200e3200b3200731005310003000030002300013000030002300013000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011300001e0301e04500005000001e02500000000000000021050210450000000000210250000000000000001a0501a05500000000001a0250000000000000001705017055000000000017055000000000000000
01130000120301204500005000000000000000000000000015050150450000000000000000000000000000000e0500e0550000000000000000000000000000000b0500b055000000000000000000000000000000
0113000017054170550e000170250e0540e055000000e02510054100550000010025120541205500000120251705417055000001702515054150550000015025100541005500000100250e0540e055000000e025
__music__
01 10154344
00 10154344
01 10151f44
00 10151e44
00 10152044
02 10151e44
00 10152044

