# an incomplete list; add more to here as we use them to make check work
TIC_GLOBALS=mget,btn,btnp,map,spr,rect,rectb,trace,pix,mset,cls

run: out.fnl; tic80 mech.tic -code-watch out.fnl

out.fnl: header.fnl dialog.fnl launch.fnl characters.fnl game.fnl
	cat $^ > $@

check: out.fnl
	fennel --globals $(TIC_GLOBALS) --compile $< > /dev/null
