(set chars.Adam {:x 40 :y 64 :name "Adam"
                 :spr 290 :portrait 288})
(set chars.Turk {:x 152 :y 8 :name "Turk"
                 :spr 322 :portrait 320})
(set chars.Hank {:x -128 :y -128 :name "Hank"
                 :spr 352 :portrait 354})
(set chars.Carrie {:x -128 :y -128 :name "Carrie"
                   :spr 384 :portrait 386})

(local all {})

(fn all.Adam []
  (say "Check out how cool my uniform is.")
  (if (= "Yes" (ask "Are you ready to launch?" ["Yes" "No"]))
      (do (reply "Let's do this!")
          (say "I was hoping you'd say that!")
          (enter-launch))
      (say "OK but don't wait too long.")))

(fn all.Turk []
  ; (describe "He seems agitated.")
  (reply "Hey, Turk.")
  (say "Nikita!! My favorite person. Make it \nquick; I've got a call with my agent in\n15 minutes.")
  (let [answer (ask "What's up?" ["Agent?" "Carrie" "Bye"])]
    (match answer
      "Carrie" (reply "I'd like you to consider letting Carrie be the head. She-")
      "Agent" (reply "Oooo, agent, eh? What's going\non there?")
      "Bye" (do
        (reply "Nevermind. Later.")
        (describe "He seems relieved you're leaving.")))))

(each [name (pairs chars)] ; set up initial convos for each character
  (tset convos name (. all name)))
()
