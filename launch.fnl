(var (lx ly scroll-x) nil)

(local stars [])
(for [i 1 32] (table.insert stars [(math.random 480) (math.random 272)]))

(fn draw-launch []
  (cls)
  (each [_ s (ipairs stars)]
    (let [[sx sy] s]
      (pix (% (* (- sx scroll-x) 0.5) 240)
           (% (* sy 0.5) 136) 13)
      (pix (% (- sx scroll-x) 240)
           (% sy 136) 15)))
  (when (btn 4)
    (rect (+ lx 30) (+ ly 6) 240 2 1))
  (spr 484 lx ly 0 1 0 0 4 2))

;; when the game is in launch mode, this becomes the TIC updater
(fn launch []
  (set scroll-x (+ scroll-x 1))
  (when (and (btn 0) (< 0 ly)) (set ly (- ly 1)))
  (when (and (btn 1) (< ly (- 136 16))) (set ly (+ ly 1)))
  (when (and (btn 2) (< 0 lx)) (set lx (- lx 1)))
  (when (and (btn 3) (< lx (- 240 32))) (set lx (+ lx 1)))
  (draw-launch))

(fn enter-launch []
  (set (lx ly scroll-x) (values 0 (/ 136 2) 0))
  (global TIC launch))
