;; title:   this is my mech
;; author:  emma bukaceck and phil hagelberg
;; desc:    a team of mech pilots must band together
;; script:  fennel
;; license: GNU GPL v3 or later

(fn lerp [a b t]
  (+ (* a (- 1 t)) (* t b)))

(var restart nil) ; forward-declaration

(var coros []) ; things to run in the background
