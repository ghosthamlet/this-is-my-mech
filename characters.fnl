;;; character positioning, state, and dialog

(set chars.Adam {:x 40 :y 64 :name "Adam"
                 :spr 290 :portrait 288 :helmet 291})
(set chars.Turk {:x 152 :y 8 :name "Turk"
                 :spr 322 :portrait 320  :helmet 323})
(set chars.Hank {:x 264 :y 2 :name "Hank"
                 :spr 354 :portrait 352 :helmet 355})
(set chars.Carrie {:x 84 :y 300 :name "Carrie"
                   :spr 386 :portrait 384 :helmet 387})
(set chars.Nikita {:x -256 :y -256 :name "Nikita"
                   :spr 258 :portrait 256 :helmet 259})

(set chars.alert {:x -256 :y -256 :name "alert" :portrait 420 :spr 420})

(fn move-to [character-name tx ty]
  (let [char (assert (. chars character-name) (.. character-name " not found"))]
    (fn mover []
      (let [dx (- tx char.x) dy (- ty char.y)]
        (while (not (and (= 0 dx) (= 0 dy)))
          (set char.x (+ char.x (if (< dx 0) -1 (> dx 1) 1 (< dx 1) dx 0)))
          (set char.y (+ char.y (if (< dy 0) -1 (> dy 1) 1 (< dy 1) dy 0)))
          (coroutine.yield)
          (mover))))
    (table.insert coros (coroutine.create mover))))

(local all {})
(local hank-conversations {})
(local hank-state {:disposition 0})

(fn update-hank-disposition [change]
  (set hank-state.disposition (+ change hank-state.disposition)))

(fn all.Adam []
  (say "Check out how cool my uniform is.")
  (describe  "He chuckles obnoxiously.")
  ;; LATER
  (describe "There's that damn chuckle again.")
  ;; EVEN LATER
  (describe "UGH STOP CHUCKLING DAMN IT.")
  (say "I'm going to walk north for some" " reason.")
  ;; TODO: delete this; it's dumb
  (move-to :Adam 40 (- chars.Adam.y 10)))

(fn all.Turk []
  (describe "Turk seems a little agitated.")
  (reply "Hey, Turk.")
  (say "Nikita!! My favorite person. Make it"
       "quick; I've got a call with my agent"
       "in 15 minutes.")
  (let [answer (ask "What's up?" ["Agent?" "Carrie" "Bye"])]
    (if (= answer "Agent?")
      (reply "Oooo, agent, eh?"
             "What's going\non there?")
      (= answer "Carrie")
      (do
        (reply "I'd like you to consider letting Carrie"
               "be the head when we form up. She-")
        (say "Let me just stop you right there."
             "I NEED to be the head."))
      (do
        (reply "Nevermind. Later.")
        (describe "He seems relieved you're leaving.")))))

(fn all.Hank []
  (if
    (>= hank-state.disposition 0)
    (if
      (has-happened :hank-has-explained-his-idea)
      (let [answer (ask "Greetings. What can I do for you?"
                        ["I'd like Carrie to be the head" "Nevermind"])]
        (if (= answer "I'd like Carrie to be the head")
          (= answer "Nevermind")
          (do
            (reply "Nevermind. My bad.")
            (describe "He nods, then curtly turns around"
                      "with his hands clasped behind his back."))))
      (do
        (say "Oh, it's you. Hi Nikita.")
        (let [answer (ask "Have I told you about my project?"
                          ["Let's hear it!" "Maybe later!" "Oh look at the time."])]
          (if (= answer "Let's hear it!")
            (hank-conversations.explain-idea)
            (= answer "Maybe later!")
            (say "Sure!")
            (= answer "Oh look at the time.")
            (do (say "Uh... all right then, I guess.")
              (describe "He stares at his feet as you leave."))))))
    (< hank-state.disposition 0)
    (if
      (has-happened :nikita-talked-to-pissed-off-hank)
      (reply "I better leave him alone.")
      (do
        (publish {:event :nikita-talked-to-pissed-off-hank})
        (reply "Hank?")
        (say "...")
        (describe "He's ignoring you.| Dang it.")))
    (or
      (has-happened :nikita-frustrated-hank)
      (has-happened :carrie-disagrees-with-hanks-plan))
    (say "Look, I'm not in the mood to talk, okay?")
    (reply "I better leave him alone.")))



(fn hank-conversations.explain-idea []
  (say "I built a new targeting system for"
       "Rhinocelator! It utilizes machine"
       "learning algorithms and block chain"
       "validation!")
  (say "It works by applying techno babble"
       "to mainframe databases through a"
       "triangulated Thoralin pipe!")
  (reply "...oh, nice!")
  (describe "You nod with...|'understanding'")
  (say "It's still a prototype, but with"
       "suitable data, it could be quite"
       "revolutionary! Our next mission is"
       "an ideal opportunity to perform"
       "research and install it!")
  (say "With a little effort, I believe our"
       "damage output will increase by"
       "at least 57%!")
  (let [answer
        (ask "What do you think?"
             ["Thoralin pipe?" "Great idea!" "Well.." "What a crock."])]
          (if (= answer "Thoralin pipe?")
              (hank-conversations.ask-more-about-idea)
              (= answer "Great idea!")
              (hank-conversations.support-idea)
              (= answer "Well..")
              (hank-conversations.do-not-support-idea)
              (= answer "What a crock.")
              (do
                (update-hank-disposition -1)
                (reply "You know you just said a lot of"
                       "techno babble bullshit, right?")
                (say "Egad! First off-")
                (reply "And don't you need like, tens of"
                       "thousands of samples to train a"
                       "machine learning algorithm?")
                (say "Well, I mean..| it depends!")
                (describe "Hank's cheeks are practically"
                          "bleeding from blushing."
                          "|"
                          "Someone call the doc.")
                (hank-conversations.do-not-support-idea)))))

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
       "a schwub like a plumbus.")
  (reply "Of course! Duh. Thanks for clearing"
         "that up for me.")
  (let [answer (ask "Do you think it will work?"
                ["Yes" "It's not practical"])]
    (if (= answer "Yes")
      (hank-conversations.support-idea)
      (= answer "It's not practical")
      (hank-conversations.do-not-support-idea))))

(fn hank-conversations.support-idea []
  (publish {:event :supported-hanks-idea}
           {:event :hank-has-explained-his-idea})
  (reply "Wow, great idea! I know it could be"
         "burdensome to us at first, but our"
         "next fight is as good as any!")
  (say "Thank you! Finally someone who"
       "understands the complexity"
       "of my intellect.")
  (describe "Sixty-two eyebrows just raised"
            "across the galaxy.")
  (reply "...Sure!")
  (say "This idea is what's best for our"
       "team even if the others"
       "can't see that.")
  (say "It is illogical to think"
       "this idea *wouldn't* work, but I"
       "suppose some folks in this world"
       "just do not understand...")
  (say "...|*especially* Carrie! She has"
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
            (say "|!!!")
            (describe "Hank frowns and almost says"
                      "something, but slowly closes his"
                      "mouth instead."
                      "|"
                      "He glares through you.")
            (say "...")
            (describe "He returns to his work.")
            (reply "Well. That pissed him off."))
          (= answer "Hey now.")
          (do
            (reply "Whoa, whoa. I know you two have"
                   "your differences, but you both want"
                   "what's best for the team and you"
                   "both have great ideas.")
            (reply "Perhaps there's an opportunity"
                   "for compromise between you two.")
            (say "...|perhaps you are correct. That"
                 "being said, I still don't understand"
                 "why you would side with her over me.")
            (reply "I'm not picking sides. I'm just saying"
                   "you two can work this out.")
            (say "Whatever, Nikita. Honestly, it's fine."
                 "|I understand. I know I will have"
                 "your support when I propose this."
                 "Thanks.")
            (describe "He nods half-assedly and returns to"
                      "his work."
                      "|"
                      "*sigh*"))
          (= answer "Makes sense to me")
          (do
            (update-hank-disposition 1)
            (reply "Yeah...Carrie can be a bit of a"
                   "jerk at times.")
            (describe "He nods.")
            (say "Anyway. Thanks for your support. I"
                 "know you've got my back.")
            (describe "He returns to his work."))
          (= answer "...")
          (do
            (reply "...")
            (say "Well. Thanks for your support. I"
                 "trust you'll have my back when I"
                 "present this to the others.")
            (describe "He returns to his work.")))))

;; TODO: Fill in
(fn hank-conversations.do-not-support-idea [remove-reassure?]
  (publish {:event :didnt-support-hanks-idea}
           {:event :hank-has-explained-his-idea})
  (when (not remove-reassure?)
        (say "I should have known you would not"
             "support me! You're just like the"
             "rest."))
  (let [questions ["Reassure" "Present Facts" "Poke fun" "..."]
        _ (when remove-reassure?
            (table.remove questions 1))
        answer (ask "" questions)]
        (if (= answer "Reassure")
            (do
              (update-hank-disposition 1)
              (reply "Reassuring thing.")
              (describe "Hank won't say it, but he"
                        "appreciates you.")
              (hank-conversations.do-not-support-idea true))
            (= answer "Present Facts")
            (if (> hank-state.disposition 2)
                (hank-conversations.willing-to-negotiate)
                (do
                  (say "Annoyed and won't listen to reason.")
                  (update-hank-disposition -1)))
            (= answer "Poke fun")
            (do
              (update-hank-disposition -1)
              (reply "Poke fun"))
            (= answer "...")
            (do
              (update-hank-disposition -1)
              (reply "...")
              (say "Fine. Don't say anything. Your loss.")
              (describe "Hank turns his back to you.")))))

(fn hank-conversations.willing-to-negotiate []
  ;; TODO: Fill out
  (say "I'm beginning to see your point, but")
  (let [answer (ask "" ["Experiment in your own time"
                        "Let's try later"
                        "Let's simplify your test"])]
    (if
      (= answer "Experiment in your own time")
      (do
        (publish {:event :nikita-frustrated-hank})
        (reply "Hank, our lives are at stake."
               "I love the fact that you are eager"
               "to improve our systems, but you should"
               "experiment in your own time.")
        (say "But this will benefit us all! It could"
             "even *save* our lives!")
        (reply "Hank, really! Now is not the time.")
        (describe "Frustrated, he lets out a massive sigh"
                  "and turns his back to you."))
      (= answer "Let's try later")
      (do
        (publish {:event :nikita-frustrated-hank})
        (reply "You've got a great idea here, Hank."
               "But now is not the time. We need"
               "stability. Perhaps we can try later?")
        (say "It's always later! This team never"
             "understands me and evidently neither"
             "do you.")
        (describe "He turns around before you can reply."))
      (= answer "Let's simplify")
      (do
        (reply "You have an awesome idea, Hank!"
               "But I think we could simplify here.")
        (reply "What if we run your system in parallel"
               "with our existing system, gather telemtry,"
               "then present this to the team")
        (reply "Backed with the right data, the rest"
               "of the team would have no choice but to"
               "agree!")
        (say "It's not as fast as I would like, but"
             "I cannot say I would disagree with you.")
        (say "Now we just need to convince Carrie!")
        (reply "Okay. I'll chat with her and see what"
               "she thinks. Keep the good ideas coming,"
               "Hank!")
        (describe "He flashes a wry smile, then returns"
                  "to his work. Way to compromise, girl.")))))

(fn all.Carrie []
  (say "Uh oh, not another space beast.")
  (reply "Are you worried?")
  (say "It's just that... we haven't been"
       "working together as a team very well"
       "recently.")
  (say "We got lucky in our last battle since"
       "MegaMoth ran into that huge solar" "collector.")
  (say "But if we can't form up this time...")
  (say "Well, I better get my gear.")
  (move-to :Carrie 142 302)
  (set convos.Carrie all.Carrie2))

(fn all.Carrie2 []
  (say "Now where did I put my helmet?"))

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
