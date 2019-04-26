;;; win state animations

(local flipped {:Nikita true :Adam true :Carrie true})

(fn split-faces []
  (line 60 0 120 136 5)
  (line 180 0 120 136 5)
  (line 0 74 90 68 5)
  (line 239 74 150 68 5)
  (spr 387 96  6 0 3 0 0 2 2)
  (spr 323 8   12 0 3 0 0 2 2)
  (spr 291 184 12 0 3 0 0 2 2)
  (spr 355 32  80 0 3 0 0 2 2)
  (spr 259 160 80 0 3 0 0 2 2))

(var (rx rdx) nil)

(fn draw-win []
  (cls)
  (draw-stars 0 scroll-x)
  (each [name mech (pairs mechs)]
    (spr mech.spr mech.x mech.y 0 1
         (if (. flipped name) 1 0)
         3 4 2))
  (when (<= -220 mechs.Nikita.y -40)
    (split-faces)
    (when (<= mechs.Nikita.y -72)
      (print "FORM RHINOCELATOR!" 16 64 15 false 2))
    (when (<= mechs.Nikita.y -150)
      (print "YEAH" 90 80 15 false 3)))
  (when (<= mechs.Nikita.y -220)
    (set rx (+ rx rdx))
    (set rdx (+ rdx 0.02))
    (if (< rx 48)
        (set mx (- mx 0.7))
        (set mx (+ mx (* rdx 1.2))))
    (spr 261 rx 16 0 1 0 0 6 8)
    (spr 268 mx my 0 1 0 0 4 6)
    (when (< 240 rx)
      (print "Earth is safe" 46 16 15 false 2)
      (print "YOU WIN" 42 48 15 false 4)
      (print "thanks for playing!" 68 120 2)
      (print "press ESC to see how the game was made" 16 130 2))))

(fn win []
  (set scroll-x (- scroll-x 3))
  (each [name mech (pairs mechs)]
    (set mech.x (lerp mech.x 120 0.009))
    (set mech.y (- mech.y 1)))
  (pmem 0 0) ; reset restart-counter back to zero
  (draw-win))

(set enter-win
     (fn []
       (set (scroll-x rx rdx mx my) (values 0 16 0.5 168 28))
       (let [init-ys {:Adam 8 :Turk 8 :Carrie 0 :Hank 12 :Nikita 12}
             init-xs {:Adam 100 :Turk 40 :Carrie 68 :Hank 15 :Nikita 120}]
         (each [name mech (pairs mechs)]
           (set mech.x (* (. init-xs name) 1.8))
           (set mech.y (+ 128 (. init-ys name)))))
       (global TIC win)))
