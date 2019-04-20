(set chars.Adam {:x 40 :y 64 :name "Adam"
                 :spr 290 :portrait 288})
(set chars.Turk {:x -128 :y -128 :name "Turk"
                 :spr 320 :portrait 322})
(set chars.Hank {:x -128 :y -128 :name "Hank"
                 :spr 352 :portrait 354})
(set chars.Carrie {:x -128 :y -128 :name "Carrie"
                   :spr 384 :portrait 386})

(local all {})

(fn all.Adam []
  (say "Check out how cool my uniform is.")
  (if (= "Yes" (ask "Are you ready to launch?" ["Yes" "No"]))
      (enter-launch)
      (say "OK but don't wait too long.")))

(each [name (pairs chars)] ; set up initial convos for each character
  (tset convos name (. all name)))

