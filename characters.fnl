(set chars.Adam {:x 40 :y 64 :name "Adam"
                 :spr 290 :portrait 288})
(set chars.Turk {:x 152 :y 8 :name "Turk"
                 :spr 322 :portrait 320})
(set chars.Hank {:x 264 :y 2 :name "Hank"
                 :spr 354 :portrait 352})
(set chars.Carrie {:x -128 :y -128 :name "Carrie"
                   :spr 386 :portrait 384})

(local all {})

(fn all.Adam []
  (say "Check out how cool my uniform is.")
  (if (= "Yes" (ask "Are you ready to launch?" ["Yes" "No"]))
      (do (reply "Let's do this!")
          (say "I was hoping you'd say that!")
          (enter-launch))
      (say "OK but don't wait too long.")))

(fn all.Turk []
  (describe "Turk seems a little agitated.")
  (reply "Hey, Turk.")
  (say "Nikita!! My favorite person. Make it"
       "quick; I've got a call with my agent in"
       "15 minutes.")
  (let [answer (ask "What's up?" ["Agent?" "Carrie" "Bye"])]
    (if (= answer "Agent?")
        (reply "Oooo, agent, eh?"
               "What's going\non there?")
        (= answer "Carrie")
        (do
          (reply "I'd like you to consider letting Carrie be the head. She-")
          (say "Let me just stop you right there."
               "I NEED to be the head."))
        (do
          (reply "Nevermind. Later.")
          (describe "He seems relieved you're leaving.")))))

(fn all.Hank []
  (say "Oh, it's you. Hi Nikita.")
  (let [answer (ask "Have I told you about my project?"
                    ["What is it?" "Maybe later!" "Oh look at the time."])]
    (if (= answer "What is it?")
        (do (say "I built a new targeting system for"
                 "Rhinocelator! It uses machine"
                 "learning algorithms!")
            (reply "Oh! Interesting."
                   "How well does it work?")
            (say "I'm not sure yet. I want to use it on"
                 "our next mission to find out!"
                 "It could be pretty revolutionary!")
            (reply "Don't you think you should test"
                   "it in a less dangerous setting?")
            (say "Come on, Nikita! It'll be fine!"
                 "Don't be such a spoilsport."))
        (= answer "Maybe later!")
        (say "Sure!")
        (= answer "Oh look at the time.")
        (do (say "Uh... all right then, I guess.")
            (describe "He stares at his feet as you leave.")))))

(each [name (pairs chars)] ; set up initial convos for each character
  (tset convos name (. all name)))
