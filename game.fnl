;;;; game code

(local (w h) (values 240 136))
(local (center-x center-y) (values (/ w 2) (/ h 2)))
(var (x y cam-x cam-y) nil)

(fn filter [f t]
  (local res [])
  (each [_ x (pairs t)]
    (when (f x) (table.insert res x)))
  res)

(fn hit? [px py char]
  (and (<= char.x px (+ char.x (- (* (or char.w 1) 8) 1)))
       (<= char.y py (+ char.y (- (* (or char.h 2) 8) 1)))))

(fn can-move-point? [px py]
  (and (= 1 (mget (// px 8) (// py 8)))
       (= 0 (# (filter (partial hit? px py) chars)))))

(fn can-move? [x y]
  (and (can-move-point? x y)
       (can-move-point? (+ x 6) y)
       (can-move-point? x (+ y 7))
       (can-move-point? (+ x 6) (+ y 7))))

(fn move []
  (let [dx (if (btn 2) -1 (btn 3) 1 0)
        dy (if (btn 0) -1 (btn 1) 1 0)]
    (if (can-move? (+ x dx) (+ y dy 8))
        (set (x y) (values (+ x dx) (+ y dy)))
        (can-move? (+ x dx) (+ y 8))
        (set x (+ x dx))
        (can-move? x (+ y dy 8))
        (set y (+ y dy)))))

(fn init []
  (set (x y cam-x cam-y) (values 39 304 center-y center-x center-y)))

(fn draw-dialog []
  (when said
    (rect 0 0 238 42 13)
    (rectb 1 1 236 40 15)
    (print said 32 6)
    (when (and who who.portrait (not replying))
      (print who.name 5 26)
      (spr who.portrait 8 6 0 1 0 0 2 2))
    (when (and who who.portrait replying)
      (print "Nikita" 5 26)
      (spr 256 8 6 0 1 0 0 2 2))
    (when choices
      (each [i ch (ipairs choices)]
        (when (= i choice)
          (print ">" 30 (+ 8 (* 8 i))))
        (print ch 38 (+ 8 (* 8 i)))))))

(fn draw []
  (set cam-x (math.min center-x (lerp cam-x (- center-x x) 0.05)))
  (set cam-y (math.min center-y (lerp cam-y (- center-y y) 0.05)))
  (draw-stars (* cam-x -0.6) (* cam-y -0.6))
  (map (// (- cam-x) 8) (// (- cam-y) 8)
       32 19 (- (% cam-x 8) 8)
       (- (% cam-y 8) 8) 0)
  (each [name c (pairs chars)]
    (when c.spr
      (spr c.spr (+ cam-x c.x) (+ cam-y c.y) 0 1 0 0 (or c.w 1) (or c.h 2))))
  (spr 258 (+ x cam-x) (+ y cam-y) 0 1 0 0 1 2)
  (draw-dialog))

(init)

;; the walk-around-and-talk section of the game
(fn main []
  (cls)
  (draw)
  (when (btnp 6) (trace (.. x " " y))) ; for debug
  (let [talking-to (dialog x y (btnp 4) (btnp 5))]
    (if (and talking-to (btnp 0)) (choose -1)
        (and talking-to (btnp 1)) (choose 1)
        (not talking-to) (move)))
  (when (and (btn 4) (btn 5) (btn 6)) (enter-launch)) ; for debugging
  (when (and (btn 4) (btn 6)) (enter-win))
  (for [i (# coros) 1 -1]
    (coroutine.resume (. coros i))
    (when (= :dead (coroutine.status (. coros i)))
      (table.remove coros i))))

(fn intro []
  (cls)
  (draw-stars cam-x cam-y)
  (print "t  h  i  s        i  s        m  y" 24 10)
  (map 92 55 14 4 10 26 0 2)
  (set cam-x (+ cam-x 2))
  (print "by Emma Bukacek and Phil Hagelberg" 28 110)
  (print "press Z" (+ (* 128
                         (- 1 (math.abs (- 1 (math.fmod (/ cam-x 100) 2)))))
                      32) 124 2)
  (for [i 0 5]
    (when (btnp i)
      (set cam-x 96)
      (global TIC main))))

(trace "Press ESC again to see how it was made!")
(global TIC intro)
(set restart (fn [] (init) (global TIC main)))
