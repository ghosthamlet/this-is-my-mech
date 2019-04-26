# an incomplete list; add more to here as we use them to make check work
TIC_GLOBALS=mget,btn,btnp,map,spr,rect,rectb,trace,pix,mset,cls,line,sfx

SRC=header.fnl dialog.fnl launch.fnl win.fnl characters.fnl game.fnl

run: out.fnl
	ls *fnl | entr make out.fnl &
	tic80 mech.tic -code-watch out.fnl

out.fnl: $(SRC) ; cat $^ > $@

check: out.fnl ; fennel --globals $(TIC_GLOBALS) --compile $< > /dev/null

count: out.fnl ; cloc $^

# run "export" in TIC80's shell to create mech.tic.html
upload: mech.tic.html
	cp $^ index.html
	butler push index.html technomancy/this-is-my-mech:mech.tic.html

todo: ; grep TODO $(SRC)
