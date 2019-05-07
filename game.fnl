(local (w h) (values 240 136))
(local (center-x center-y) (values (/ w 2) (/ h 2)))
(var (cam-x cam-y) (values center-x center-y))

(fn filter [f t]
  (local res [])
  (each [_ x (pairs t)]
    (when (f x) (table.insert res x)))
  res)

(fn hit? [px py char]
  (and (~= :Nikita char.name)
       (<= char.x px (+ char.x (- (* (or char.w 1) 8) 1)))
       (<= char.y py (+ char.y (- (* (or char.h 2) 8) 1)))))

(fn can-move-point? [px py thru-chars?]
  (and (= 1 (mget (// px 8) (// py 8)))
       (or thru-chars? (= 0 (# (filter (partial hit? px py) chars))))))

(fn can-move? [x y thru-chars?]
 (and (can-move-point? x y thru-chars?)
  (can-move-point? (+ x 6) y thru-chars?)
  (can-move-point? x (+ y 7) thru-chars?)
  (can-move-point? (+ x 6) (+ y 7) thru-chars?)))

(fn move []
  (let [amt (if (btn 5) 1.7 1)
        dx (if (btn 2) (- amt) (btn 3) amt 0)
        dy (if (btn 0) (- amt) (btn 1) amt 0)
        x chars.Nikita.x
        y chars.Nikita.y]
    (if (can-move? (+ x dx) (+ y dy 8))
        (set (chars.Nikita.x chars.Nikita.y) (values (+ x dx) (+ y dy)))
        ;; if you're stuck at the start of the frame, don't let character
        ;; collisions stop you from getting un-stuck
        (and (not (can-move? x (+ 8 y))) (can-move? (+ x dx) (+ y dy 8) true))
        (set (chars.Nikita.x chars.Nikita.y) (values (+ x dx) (+ y dy)))
        (can-move? (+ x dx) (+ y 8))
        (set chars.Nikita.x (+ x dx))
        (can-move? x (+ y dy 8))
        (set chars.Nikita.y (+ y dy)))))

(fn init []
 (each [k (pairs hank-state)] (tset hank-state k nil))
 (each [k v (pairs events)]
  (tset prev-events k v)
  (tset events k nil))
 (set hank-state.disposition 0)
 (set choices nil)
 (math.randomseed (time))
 (each [name pos (pairs initial-positions)]
  (let [[x y] pos]
   (tset (. chars name) :x x)
   (tset (. chars name) :y y)))
 (fn opening []
  (say-as :alert "Warning! Hostile space beast" "detected inbound!" ""
   "All mech pilots,| prepare for launch.")
  (when last-losing
   (let [tip-to-show (if next-tip next-tip (+ (math.floor (* (math.random) 5)) 1))]
    (set next-tip nil)
    (if (= tip-to-show 1)
     (describe "HINT: Don't forget, you need to"
      "convince everyone to support Carrie"
      "as the head to have a successful"
      "battle! Don't be a jerk.")
     (= tip-to-show 2)
     (describe "HINT: Hank is sensitive, but he will"
      "respect you more if you're honest"
      "about the feasibility of his ideas."
      "It doesn't hurt to reassure him,"
      "either.")
     (= tip-to-show 3)
     (describe "HINT: Damn, did we make this game"
     "too difficult? Just know that Turk"
     "and Adam's plotlines are relatively"
     "linear. It's all about convincing"
     "Hank.")
     (= tip-to-show 4)
     (describe "HINT: Can't figure it out? Just"
     "read the source code by pressing"
     "escape. ( o _ʖ o)")))))
 (set-dialog opening)
 (music 1 0)
 (each [name (pairs chars)]
  (tset convos name (. all name)))
 (when last-losing
  (set chars.Nikita.x 157)
  (set chars.Nikita.y 153)
  (set chars.Turk.x 179)
  (set chars.Turk.y 96)
  (set chars.Carrie.x 102)
  (set chars.Adam.y 25)
  (set convos.Adam (partial all.Adam2 true))
  (set convos.Turk all.Turk2))
 (for [i (# coros) 1 -1] (table.remove coros i)))

(fn draw []
  (set cam-x (math.min center-x (lerp cam-x (- center-x chars.Nikita.x) 0.05)))
  (set cam-y (math.min center-y (lerp cam-y (- center-y chars.Nikita.y) 0.05)))
  (draw-stars (* cam-x -0.6) (* cam-y -0.6))
  (map (// (- cam-x) 8) (// (- cam-y) 8)
       32 19 (- (% cam-x 8) 8)
       (- (% cam-y 8) 8) 0)
  (each [name c (pairs chars)]
    (when c.spr
      (spr c.spr (+ cam-x c.x) (+ cam-y c.y) 0 1 0 0 (or c.w 1) (or c.h 2))))
  (let [c chars.Nikita]
    (spr c.spr (+ cam-x c.x) (+ cam-y c.y) 0 1 0 0 (or c.w 1) (or c.h 2)))
  (draw-dialog :portrait))

(fn main []
 (cls)
 (draw)
 (when (btnp 6)
  (set-dialog (fn []
               (set who nil)
               (let [choice (ask "" ["Restart" "Cancel"])]
                (when (= choice "Restart")
                 (restart))))))
 (let [talking-to (dialog chars.Nikita.x chars.Nikita.y (btnp 4))]
  (if (and talking-to (btnp 0)) (choose -1)
   (and talking-to (btnp 1)) (choose 1)
   (not talking-to) (move)))
 (for [i (# coros) 1 -1]
  (assert (coroutine.resume (. coros i)))
  (when (= :dead (coroutine.status (. coros i)))
   (table.remove coros i))))

(fn intro []
  (cls)
  (draw-stars cam-x cam-y)
  (print "t  h  i  s        i  s        m  y" 24 10)
  (map 92 55 14 4 10 26 0 2)
  (set cam-x (+ cam-x 1))
  (print "by Emma Bukacek and Phil Hagelberg" 28 100)
 (print "press Z to act"
  (+ (* 128 (- 1 (math.abs (- 1 (math.fmod (/ cam-x 75) 2))))) 32) 116 2)
 (print "press A to restart"
  (+ (* 128 (- 1 (math.abs (- 1 (math.fmod (/ (+ cam-x 45) 75) 2))))) 10)
  128 2)
  (for [i 0 5]
    (when (btnp i)
      (set cam-x 96)
      (global TIC main))))

(init)
(trace "This is the console; type run to start.")
(trace "Press ESC for the art, code, and sound.")
(global TIC intro)
(set restart (fn [] (init) (global TIC main)))
