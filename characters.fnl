(set chars.Adam {:x 40 :y 64 :name "Adam"
                 :spr 290 :portrait 288})
(set chars.Turk {:x 152 :y 8 :name "Turk"
                 :spr 322 :portrait 320})
(set chars.Hank {:x 264 :y 2 :name "Hank"
                 :spr 354 :portrait 352})
(set chars.Carrie {:x 139 :y 308 :name "Carrie"
                   :spr 386 :portrait 384})

(local all {})
(local hank-conversations {})
(local hank-state {:disposition 0})

(fn update-hank-disposition [change]
  (set hank-state.disposition (+ change hank-state.disposition)))

(fn all.Adam []
  (say "Check out how cool my uniform is."))

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
        (hank-conversations.explain-idea)
        (= answer "Maybe later!")
        (say "Sure!")
        (= answer "Oh look at the time.")
        (do (say "Uh... all right then, I guess.")
            (describe "He stares at his feet as you leave.")))))



(fn hank-conversations.explain-idea []
  (say "I built a new targeting system for"
       "Rhinocelator! It uses machine"
       "learning algorithms and block chain"
       "validation!")
  (say "It works by applying techno babble"
       "to mainframe databases through a"
       "triangulated Thoralin pipe!")
  (reply "...oh, nice!")
  (describe "You nod with.....'understanding'")
  (say "It's still a prototype, but with"
       "suitable data, it could be quite"
       "revolutionary! Our next mission is"
       "an ideal opportunity to perform"
       "research and install it!")
  (say "With a little effort, I believe our"
       "damage output will increase by"
       "at least 57%!")
  (let [answer (ask "What do you think?"
                     ["Ask more" "Back his idea" "Don't support" "Harsh don't support"])]
                    (if (= answer "Ask more")
                        (hank-conversations.ask-more-about-idea)
                        (= answer "Back his idea")
                        (hank-conversations.support-idea)
                        (= answer "Don't support")
                        (hank-conversations.do-not-support-idea)
                        (= answer "What a crock")
                        (reply "You know you just said a lot of"
                               "techno babble bullshit, right?")
                        (say "Egad! First off-")
                        (reply "And don't you need like, tens of"
                               "thousands of samples to train a"
                               "machine learning algorithm?")
                        (say "Well, I mean.. it depends!")
                        (describe "Hank's cheeks are practically bleeding"
                                  "from blushing. Someone call the doc.")
                        (hank-conversations.do-not-support-idea))))

(fn hank-conversations.ask-more-about-idea []
  (update-hank-disposition 1)
  (reply "Actually, the triangulated Thoralin"
         "pipe part confused me. I've only"
         "seen those work as schwubs or"
         "splurns in router systems."
         "How do they work here?")
  (say "Good question!")
  (describe "Hank grins widely. He's filled with"
            "motivation at the fact that you"
            "actually paid attention.")
  (say "When you determine the wronskian of"
       "the triangulated values, then bisect"
       "that over typical machine learning"
       "algorithms, the result is a Thoralin"
       "pipe.")
  (say "Or in other words, you just treat"
       "a schwub like a plurn.")
  (reply "Of course! Duh. Thanks for clearing"
         "that up for me.")
  (let [answer (ask "So..do you think it'll work?"
                ["Yes" "It's not practical"])]
    (if (= answer "Yes")
      (hank-conversations.support-idea)
      (= answer "It's not practical")
      (hank-conversations.do-not-support-idea))))

(fn hank-conversations.support-idea []
  (publish {:event :supported-hanks-idea})
  (say "Fantastic! Granted, it is illogical to"
       "think this idea *wouldn't* work, but"
       "I suppose some folks in this world"
       "just do not understand...")
  (say "... *especially* Carrie! She has"
       "contested this idea from the start!"
       "So I'm sure you can imagine my"
       "delight at your support.")
  (let [answer (ask ""
        ["What the hell?" "Hey now." "Makes sense to me" "..."])]
        (if
          (= answer "What the hell?")
          (do
            (update-hank-disposition -2)
            (reply "Don't be a dick, Hank. Carrie is"
                   "just being realistic. Plus you"
                   "know how pretentious you can get."
                   "Let's cut the shit.")
            (say "!!!")
            (describe "Hank frowns and almost says"
                      "something, but slowly closes his"
                      "mouth instead."
                      ""
                      ;; TODO PAUSE HERE
                      "He glares through you.")
            (say "...")
            (describe "He returns to his work.")
            (reply "Well. That pissed him off.")
            (publish {:event :hank-has-explained-his-idea}))
          (= answer "Hey now.")
          (do
            (reply "Whoa, whoa. I know you two have"
                   "your differences, but you both want"
                   "what's best for the team and you"
                   "both have great ideas.")
            (reply "Perhaps there's an opportunity"
                   "for compromise between you two.")
            ;; TODO PAUSE HERE
            (say "...perhaps you are correct. That"
                 "being said, I still don't understand"
                 "why you would side with her over me.")
            (reply "I'm not picking sides. I'm just saying"
                   "you two can work this out.")
            (say "Whatever, Nikita. Honestly, it's fine."
                 "I understand. I know I will have"
                 "your support when I propose this."
                 "Thanks.")
            (describe "He nods half-assedly and returns to"
                      "his work."
                      ""
                      ;; TODO PAUSE HERE
                      "*sigh*")
            (publish {:event :hank-has-explained-his-idea}))
          (= answer "Makes sense to me")
          (do
            (reply "Wow, great idea! I know it could be"
                   "burdensome to us at first, but our"
                   "next fight is as good as any!")
            (say "Thank you! Finally someone who"
                 "understands the complexity"
                 "of my intellect.")
            (describe "Sixty-two eyebrows just raised"
                      "across the galaxy.")
            (reply "...Sure!")
            (publish {:event :hank-has-explained-his-idea}) )
          (= answer "...")
          (do
            (reply "...")
            (say "Well. Thanks for your support. I"
                 "trust you'll have my back when I"
                 "present this to the others.")
            (publish {:event :hank-has-explained-his-idea})))))

(fn all.Carrie []
  (say "How's it going?")
  (reply "Good to see you again.")
  (say "I'm a bit worried about the next"
       "mission. If we can't form up we"
       "might not stand a chance."))

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
(fn all.mech-nikita []
  (describe "This is your mech.")
  (when (= "Yes" (ask "Are you ready to launch?" ["Yes" "No"]))
      (reply "Let's do this!")
      (enter-launch)))

(set chars.turk-photo {:x 13 :y 200 :spr 190 :w 2 :h 2})
(fn all.turk-photo []
  (describe "Only Turk would have a photo of"
            "himself in his quarters.")
  (describe "Hmm...why am *I* in here?"))

(each [name (pairs chars)] ; set up initial convos for each character
  (tset convos name (. all name)))
