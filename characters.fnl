;;; character positioning, state, and dialog

(local initial-positions {:Adam [48 64] :Turk [85 215] :Hank [264 16] :Carrie [84 300] :Nikita [39 304]})

(set chars.Adam {:name "Adam" :spr 290 :portrait 288 :helmet 291})
(set chars.Turk {:name "Turk" :spr 322 :portrait 320  :helmet 323})
(set chars.Hank {:name "Hank" :spr 354 :portrait 352 :helmet 355})
(set chars.Carrie {:name "Carrie" :spr 386 :portrait 384 :helmet 387})
(set chars.Nikita {:name "Nikita" :spr 258 :portrait 256 :helmet 259})

(set chars.alert {:x 0 :y 0 :name "alert" :portrait 420})

(fn mover-actions [coords]
  (let [action (. coords 1)
        value (. coords 2)]
    (when (= action :wait)
      (do
        (for [i 1 value] (coroutine.yield))
        (table.remove coords 1)))))

(fn move-to [character-name ...]
  (let [char (assert (. chars character-name) (.. character-name " not found"))
        coords [...]]
    (set char.moving? true)
    (fn mover []
        (let [[tx ty] coords
                      dx (- tx char.x) dy (- ty char.y)]
          (set char.x (+ char.x (if (< dx 0) -1 (> dx 1) 1 (< dx 1) dx 0)))
          (set char.y (+ char.y (if (< dy 0) -1 (> dy 1) 1 (< dy 1) dy 0)))
          (coroutine.yield)
          (when (and (<= (math.abs dx) 1) (<= (math.abs dy) 1))
            (table.remove coords 1)
            (table.remove coords 1))
          (if (. coords 1)
              (mover)
              (set char.moving? false))))
    (table.insert coros (coroutine.create mover))))

(local all {})
(local carrie-conversations {})
(local hank-conversations {})
(local hank-state {:disposition 0})

(fn update-hank-disposition [change]
  (set hank-state.disposition (+ change hank-state.disposition)))

;; non-character "dialog"

(set chars.mech-adam {:x 240 :y 129 :spr 416 :w 4})
(set chars.mech-turk {:x 240 :y 161 :spr 448 :w 4})
(set chars.mech-hank {:x 240 :y 193 :spr 480 :w 4})
(set chars.mech-carrie {:x 240 :y 225 :spr 452 :w 4})
(set chars.mech-nikita {:x 240 :y 257 :spr 484 :w 4})

(fn all.mech-adam []
  (describe "This is Adam's mech."
            "He keeps it spotless."))
(fn all.mech-turk []
  (describe "This is Turk's mech.")
  (describe "There is a faded photo of Turk taped"
            "up next to the controls."))
(fn all.mech-hank []
  (describe "This is Hank's mech.")
  (describe "He left a debugger wired into the"
            "diagnostics port. It appears to be"
            "downloading trajectory logs."))
(fn all.mech-carrie []
  (describe "This is Carrie's mech."
            "There's evidence of recent repair"
            "work on the rear flank's armor."))
(var launch-cheat false)
(fn all.mech-nikita []
  (describe "This is your mech.")
  (when (= "Yes" (ask "Are you ready to launch?" ["Yes" "No"]))
      (reply "Let's do this!")
      (enter-launch launch-cheat)))

(var poster-count 0)
(set chars.turk-photo {:x 13 :y 200 :spr 190 :w 2 :h 2})
(fn all.turk-photo []
  (set poster-count (+ poster-count 1))
  (describe "Only Turk would have a poster of"
            "himself in his quarters..."))

(set chars.bridge-screen {:x 100 :y 16 :w 3})
(fn all.bridge-screen []
  (describe "The tactical display shows the"
            "space beast's rapid approach"
            "towards Earth.")
  (describe "Sensors indicate it is impervious"
            "to beam weapons but could be driven"
            "away by an intimidating display"
            "of superior size.")
  (set events.screen-seen true))

(set chars.mech-repair {:x 200 :y 272})
(fn all.mech-repair []
  (say "Rhinocelator diagnostics system...")
  (let [mechs ["Gold Mech" "Blue Mech" "Pink Mech"
               "Purple Mech" "Black Mech"]
        m (ask "" mechs)]
    (say (.. m " is fully operational")
         "and ready to launch.")
    (when (< 5 poster-count)
      (each [i mech (pairs mechs)]
        (when (= mech m)
          (set launch-cheat i))))))

(set chars.bridge-station {:x 56 :y 22})
(fn all.bridge-station []
  (say "Enter username and password:"))
(fn all.bridge-station-auth []
  (say "Enter authentication code to log in."
       "A 4-digit code has been sent to the"
       "phone number associated with your"
       "account."))

(set chars.bridge-station2 {:x 56 :y 64})
(fn all.bridge-station2 []
  (say "You have exceeded the maximum"
       "number of attempted logins. Your"
       "account is locked. Please contact a"
       "system administrator."))

(set chars.station-computer-lab {:x 378 :y 42})
(fn all.station-computer-lab []
 (describe "The screensaver shows toasters" "flying across the screen."))

(set chars.door1 {:x 56 :y 160})
(set chars.door2 {:x 106 :y 231})
(fn all.door1 [] (describe "Locked."))
(set all.door2 all.door1)

(set chars.airlock {:x 162 :y -14})
(fn all.airlock []
  (describe "It's an airlock. Better not" "open it."))

(fn force-fail [no-chat?]
 (describe "...")
 (say-as :alert
  "The space beast is approaching!" ""
  "All mech pilots report to your" "mechs immediately and launch.")
 (when (not no-chat?) (say "Well, no time to chat."))
 (enter-launch))

(global eset (fn [event] (tset events event true))) ; debug
