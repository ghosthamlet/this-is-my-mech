;;;; game code

(local (w h) (values 240 136))
(local (center-x center-y) (values (/ w 2) (/ h 2)))
(var (x y) (values center-x center-y))
(fn move [] nil)

(fn draw []
  (map (// (- x) 8) (// (- y) 8)
       (// w 8) (// h 8)
       (- (% x 8) 8)
       (- (% y 8) 8) 0))

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
