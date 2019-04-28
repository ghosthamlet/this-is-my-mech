;;; game code, tying it all together

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
       (or thru-chars?
           (= 0 (# (filter (partial hit? px py) chars))))))

(fn can-move? [x y thru-chars?]
  (or (btn 7) ; S key is noclip; for debugging only!
      (and (can-move-point? x y thru-chars?)
           (can-move-point? (+ x 6) y thru-chars?)
           (can-move-point? x (+ y 7) thru-chars?)
           (can-move-point? (+ x 6) (+ y 7) thru-chars?))))

(fn move []
  (let [dx (if (btn 2) -1 (btn 3) 1 0)
        dy (if (btn 0) -1 (btn 1) 1 0)
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
  (math.randomseed (time))
  (each [name pos (pairs initial-positions)]
    (let [[x y] pos]
      (tset (. chars name) :x x)
      (tset (. chars name) :y y)))
  (fn opening []
    (say-as :alert "Warning! Hostile space beast" "detected inbound."
            "All mech pilots: prepare for launch."))
  (set-dialog opening)
  (each [name (pairs chars)] ; set up initial convos
    (tset convos name (. all name))))

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
  ;; render Nikita last so she's over top of any others
  (let [c chars.Nikita]
    (spr c.spr (+ cam-x c.x) (+ cam-y c.y) 0 1 0 0 (or c.w 1) (or c.h 2)))
  (draw-dialog :portrait))

;; the walk-around-and-talk section of the game
(fn main []
  (cls)
  (draw)
  (when (btnp 6) (trace (.. chars.Nikita.x " " chars.Nikita.y))) ; for debug
  (if (and said (< said-reveal (# said)) (or (btnp 5) (btnp 4)))
      (set said-reveal (# said))
      (let [talking-to (dialog chars.Nikita.x chars.Nikita.y (btnp 4) (btnp 5))]
        (if (and talking-to (btnp 0)) (choose -1)
            (and talking-to (btnp 1)) (choose 1)
            (not talking-to) (move))))
  (when (and (btn 4) (btn 5) (btn 6)) (enter-launch)) ; for debugging
  (when (and (btn 4) (btn 6)) (enter-win))
  (for [i (# coros) 1 -1]
    (assert (coroutine.resume (. coros i)))
    (when (= :dead (coroutine.status (. coros i)))
      (table.remove coros i))))

(fn intro []
  (cls)
  (draw-stars cam-x cam-y)
  (print "t  h  i  s        i  s        m  y" 24 10)
  (map 92 55 14 4 10 26 0 2) ; MECH pixel-art
  (set cam-x (+ cam-x 2))
  (print "(work-in-progress!)" 48 100 5)
  (print "by Emma Bukacek and Phil Hagelberg" 28 110)
  (print "press Z" (+ (* 128 ; bounce!
                         (- 1 (math.abs (- 1 (math.fmod (/ cam-x 100) 2)))))
                      32) 124 2)
  (for [i 0 5]
    (when (btnp i) ; lol jk you can press any key
      (set cam-x 96)
      (global TIC main))))

(init)
(trace "This is the console; type run to start.")
(trace "Press ESC for the art, code, and sound.")
(global TIC intro)
(set restart (fn []
               (init)
               (set restart-count (+ restart-count 1))
               ;; This persists the restart count across playthrus.
               ;; I'm not sure it's a great idea?
               (pmem 0 restart-count)
               (global TIC main)))
