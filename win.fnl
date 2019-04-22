(local flipped {:Nikita true :Hank true :Carrie true})

(fn draw-win []
  (cls)
  (draw-stars 0 scroll-x)
  (set scroll-x (- scroll-x 3))
  (each [name mech (pairs mechs)]
    (spr mech.spr mech.x mech.y 0 1
         (if (. flipped name) 1 0)
         3 4 2))
  (when (<= -72 mechs.Nikita.y -32)
    (rect 0 0 240 136 15))
  (when (<= -72 mechs.Nikita.y -40)
    (print "FORM RHINOCELATOR!" 16 64 0 false 2))
  (when (<= mechs.Nikita.y -72)
    ;; needs more but we'll start with this
    (spr 261 16 16 0 1 0 0 6 8)))

(fn win []
  (each [name mech (pairs mechs)]
    (set mech.x (lerp mech.x 120 0.009))
    (set mech.y (- mech.y 1)))
  (draw-win))

(fn enter-win []
  (set scroll-x 0)
  (each [name mech (pairs mechs)]
    (set mech.x (* mech.oy 1.8))
    (set mech.y (+ 128 (math.random 32))))
  (global TIC win))
