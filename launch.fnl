;; you'll eventually get different sequences here depending on actions so far
(var launch-talk [])
(var (lx ly scroll-x mx my talk-index) nil)
(var (tmx tmy dmx dmy attacking? hits) nil)

(local initial-positions {:Adam [100 15] :Turk [-50 40]
                          :Hank [10 120] :Carrie [-10 100]})

(local others {:Adam {:spr 416 :oy 15 :laser 0 :portrait 291}
               :Turk {:spr 448 :oy 40 :laser 0 :portrait 323}
               :Hank {:spr 480 :oy 120 :laser 0 :portrait 355}
               :Carrie {:spr 452 :oy 100 :laser 0 :portrait 387}})

(local stars [])
(for [i 1 32] (table.insert stars [(math.random 480) (math.random 272)]))

(fn draw-talk []
  (let [who (. launch-talk talk-index)
        words (. launch-talk (+ talk-index 1))]
    (when words
      (rect 0 0 238 42 13)
      (rectb 1 1 236 40 15)
      (print who 5 26)
      (print words 32 6)
      (spr (if (= :Nikita who) 259 ; lol this is dumb
               (. others who :portrait)) 8 6 0 1 0 0 2 2))))

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
  (let [w (if (<= my (+ y 6) (+ my 48))
              (- mx x 18)
              (- 240 x))]
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

(local max-delta 2)

(fn fly-others []
  (each [_ other (pairs others)]
    (set other.x (+ other.x other.dx))
    (set other.dx (math.min (+ other.dx (* (if (< other.x lx) 0.1 -0.1) (math.random)))
                            max-delta))
    (set other.y (+ other.y other.dy))
    (set other.dy (math.min (+ other.dy (* (if (< (- other.y other.oy) (- ly 70))
                                               0.005 -0.005) (math.random)))
                            max-delta))
    (if (and (<= other.laser 0) (< 126 (math.random 128)))
        (set other.laser (- (math.random 128) 64))
        (set other.laser (- other.laser 1)))))

(fn fly-monster []
  (set mx (+ mx dmx))
  (set my (+ my dmy))
  (set dmx (math.min (+ dmx (* (if (< mx tmx) 0.1 -0.1) (math.random))) max-delta))
  (set dmy (math.min (+ dmy (* (if (< my tmy) 0.3 -0.1) (math.random))) max-delta))
  (when attacking?
    (set (tmx tmy) (values lx (- ly 32)))))

(fn game-over []
  (global TIC (fn []
                (cls)
                (draw-stars 0 scroll-x)
                (print "GAME OVER" 32 64 15 true 3)
                (print "press Z to try again" 124 124 2)
                (set scroll-x (- scroll-x 3))
                (when (btnp 4) (restart)))))

(fn hit-check []
  (when (and (<= mx lx (+ mx 32))
             (<= my ly (+ my 48)))
    (set hits (+ hits 1)))
  (when (= hits 8)
    (set launch-talk [:Nikita "I'm taking damage!"])
    (set talk-index 1)
    (set attacking? true))
  (when (= hits 42)
    (game-over)))

;; when the game is in launch mode, this becomes the TIC updater
(fn launch []
  (set scroll-x (+ scroll-x 1))
  (when (and (btn 0) (< 0 ly)) (set ly (- ly 1)))
  (when (and (btn 1) (< ly (- 136 16))) (set ly (+ ly 1)))
  (when (and (btn 2) (< 0 lx)) (set lx (- lx 1)))
  (when (and (btn 3) (< lx (- 240 32))) (set lx (+ lx 1)))
  (when (btnp 4)
    (set talk-index (+ talk-index 2))
    (when (= :function (type (. launch-talk talk-index)))
      ((. launch-talk talk-index))
      (set talk-index (+ talk-index 1))))
  (fly-others)
  (fly-monster)
  (hit-check)
  (draw-launch))

(fn enter-launch [path]
  (set (lx ly scroll-x mx my) (values 0 (/ 136 2) 0 200 32))
  (set (tmx tmy dmx dmy attacking? hits) (values 210 48 0 0 false 0))
  (each [name pos (pairs initial-positions)]
    (let [[x y] pos]
      (tset others name :x x)
      (tset others name :y y)
      (tset others name :dx 0)
      (tset others name :dy 0)))
  (if (= path :win)
      (set launch-talk [])
      (set launch-talk
           [:Adam "Yeah! Time to assemble Rhinocelator!"
            :Adam "Enter standard formation\nso I can form the head."
            :Turk "What are you talking about?"
            :Turk "I'm going to form the head this time."
            :Hank "You formed the head last time."
            :Turk "That doesn't count!"
            :Turk "We didn't even have the\ncameras running last time."
            :Carrie "*sighs deeply*"
            :Nikita "Our weapons aren't strong enough.\nWe need to form up!"
            (fn [] (set attacking? true))
            :Adam "Look out, it's attacking!"]))
  (set talk-index 1)
  (var t -136)
  (global TIC (fn []
                (set t (+ t 5))
                (when (<= 0 t 136)
                  (launch))
                (rect 0 t 240 136 15)
                (when (< 136 t)
                  (global TIC launch)))))
