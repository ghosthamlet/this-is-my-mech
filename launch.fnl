;; you'll eventually get different sequences here depending on actions so far
(local launch-talk
       [:Adam "Yeah! Time to assemble Rhinocelator!"
        :Adam "Enter standard formation\nso I can form the head."
        :Turk "What are you talking about?"
        :Turk "I'm going to form the head this time."
        :Hank "You formed the head last time."
        :Turk "That doesn't count!"
        :Turk "We didn't even have the\ncameras running last time."
        :Carrie "*sighs deeply*"])

(var (lx ly scroll-x mx my) nil)

(local others {:Adam {:spr 416 :x 100 :y 15 :dx 0 :dy 0 :oy 15
                      :laser 0 :portrait 291}
               :Turk {:spr 448 :x -50 :y 40 :dx 0 :dy 0 :oy 40
                      :laser 0 :portrait 323}
               :Hank {:spr 480 :x 10 :y 120 :dx 0 :dy 0 :oy 120
                      :laser 0 :portrait 355}
               :Carrie {:spr 452 :x -10 :y 100 :dx 0 :dy 0 :oy 100
                        :laser 0 :portrait 387}})

(local stars [])
(for [i 1 32] (table.insert stars [(math.random 480) (math.random 272)]))

(fn draw-talk []
  (rect 0 0 238 42 13)
  (rectb 1 1 236 40 15)
  (let [[who words] launch-talk]
    (print who 5 26)
    (print words 32 6)
    (spr (. others who :portrait) 8 6 0 1 0 0 2 2)))

(fn draw-stars [scroll-x scroll-y]
  (each [_ s (ipairs stars)]
    (let [[sx sy] s]
      (pix (% (* (- sx scroll-x) 0.5) 240)
           (% (* (- sy scroll-y) 0.5) 136) 13)
      (pix (% (- sx scroll-x) 240)
           (% (- sy scroll-y) 136) 15))))

(fn draw-monster []
  (spr 268 mx my 0 1 0 0 4 6))

(fn laser [x y]
  (let [w (- 240 x)]
    (rect (+ x 30) (+ y 6) w 1 1)
    (rect (+ x 30) (+ y 7) w 1 9)))

(fn draw-launch []
  (cls)
  (draw-stars scroll-x 0)
  (each [_ other (pairs others)]
    (spr other.spr (// other.x 1) (// other.y 1) 0 1 0 0 4 2)
    (when (< 0 other.laser)
      (laser other.x other.y)))
  (when (btn 5)
    (laser lx ly))
  (spr 484 lx ly 0 1 0 0 4 2)
  (draw-monster)
  (draw-talk))

(fn fly-others []
  (each [_ other (pairs others)]
    (set other.x (+ other.x other.dx))
    (set other.dx (+ other.dx (* (if (< other.x lx) 0.1 -0.1) (math.random))))
    (set other.y (+ other.y other.dy))
    (set other.dy (+ other.dy (* (if (< (- other.y other.oy) (- ly 70))
                                     0.005 -0.005) (math.random))))
    (if (and (<= other.laser 0) (< 126 (math.random 128)))
        (set other.laser (- (math.random 128) 64))
        (set other.laser (- other.laser 1)))))

(var (tmx tmy dmx dmy) (values 210 48 0 0))

(fn fly-monster []
  (set mx (+ mx dmx))
  (set my (+ my dmy))
  (set dmx (+ dmx (* (if (< mx tmx) 0.1 -0.2) (math.random))))
  (set dmy (+ dmy (* (if (< my tmy) 0.3 -0.1) (math.random)))))

;; when the game is in launch mode, this becomes the TIC updater
(fn launch []
  (set scroll-x (+ scroll-x 1))
  (when (and (btn 0) (< 0 ly)) (set ly (- ly 1)))
  (when (and (btn 1) (< ly (- 136 16))) (set ly (+ ly 1)))
  (when (and (btn 2) (< 0 lx)) (set lx (- lx 1)))
  (when (and (btn 3) (< lx (- 240 32))) (set lx (+ lx 1)))
  (when (btnp 4)
    (table.remove launch-talk 1)
    (table.remove launch-talk 1)
    (when (not (. launch-talk 1))
      (error "game over")))
  (fly-others)
  (fly-monster)
  (draw-launch))

(fn enter-launch []
  (set (lx ly scroll-x mx my) (values 0 (/ 136 2) 0 200 32))
  (var t -136)
  (global TIC (fn []
                (set t (+ t 5))
                (when (<= 0 t 136)
                  (launch))
                (rect 0 t 240 136 15)
                (when (< 136 t)
                  (global TIC launch)))))
