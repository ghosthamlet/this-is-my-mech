;;;; game code

(local (w h) (values 240 136))
(local (center-x center-y) (values (/ w 2) (/ h 2)))
(var (x y cam-x cam-y) nil)

(fn can-move? [] true)

(fn move []
  (let [dx (if (btn 2) -1 (btn 3) 1 0)
        dy (if (btn 0) -1 (btn 1) 1 0)]
    (when (can-move? (+ x dx) (+ y dy 8))
      (set (x y) (values (+ x dx) (+ y dy))))))

(fn init []
  (set (x y cam-x cam-y) (values (/ center-x 2) center-y center-x center-y)))

(fn lerp [a b t]
  (+ (* a (- 1 t)) (* t b)))

(fn draw []
  (set cam-x (math.min center-x (lerp cam-x (- center-x x) 0.05)))
  (set cam-y (math.min center-y (lerp cam-y (- center-y y) 0.05)))
  (map (// (- cam-x) 8) (// (- cam-y) 8)
       32 19 (- (% cam-x 8) 8)
       (- (% cam-y 8) 8) 0)
  (each [name c (pairs chars)]
    (when c.spr
      (spr c.spr (+ cam-x c.x) (+ cam-y c.y) 0 1 0 0 1 2)))
  (spr 258 (+ x cam-x) (+ y cam-y) 0 1 0 0 1 2))

(init)

;; the walk-around-and-talk section of the game
(fn main []
  (cls)
  (draw)
  (let [talking-to (dialog x y (btnp 4) (btnp 5))]
    (if (and talking-to (btnp 0)) (choose -1)
        (and talking-to (btnp 1)) (choose 1)
        (not talking-to) (move)))
  (for [i (# coros) 1 -1]
    (coroutine.resume (. coros i))
    (when (= :dead (coroutine.status (. coros i)))
      (table.remove coros i))))

(global TIC main)
