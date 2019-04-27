;;; character positioning, state, and dialog

(local initial-positions {:Adam [48 64]
                          :Turk [85 215]
                          :Hank [264 16]
                          :Carrie [84 300]
                          :Nikita [39 304]
                          ; :Nikita [289 14]
                          })

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
    (fn mover []
        (let [[tx ty] coords
                      dx (- tx char.x) dy (- ty char.y)]
          (set char.x (+ char.x (if (< dx 0) -1 (> dx 1) 1 (< dx 1) dx 0)))
          (set char.y (+ char.y (if (< dy 0) -1 (> dy 1) 1 (< dy 1) dy 0)))
          (coroutine.yield)
          (when (and (<= (math.abs dx) 1) (<= (math.abs dy) 1))
            (table.remove coords 1)
            (table.remove coords 1))
          (when (. coords 1)
            (mover))))
    (table.insert coros (coroutine.create mover))))

(local all {})
(local hank-conversations {})
(local hank-state {:disposition 0})

(local carrie-conversations {})

(fn update-hank-disposition [change]
  (set hank-state.disposition (+ change hank-state.disposition)))

;;; ADAM

(fn all.Adam []
  (say "I... um. Hang on.")
  (move-to :Adam 48 25)
  (set convos.bridge-station all.bridge-station-auth)
  (set convos.Adam (fn []
                     (say "Oops.")
                     (set convos.Adam all.Adam2)
                     (all.Adam2))))

(fn adam-mention-turk []
  (say "If I don't form the head, then"
       "Turk is going to do it. "
       "Don't get me wrong; I like the guy"
       "a lot! But ...")
  (say "He just isn't leadership material!"
       "He jokes around all the time and"
       "doesn't take his job seriously.")
  (set events.adam-mentions-turk true))

(fn all.Adam2 []
  (say "Hey, sorry about that.")
  (let [r (ask "What's up?" ["What are you doing?" "Where's the restroom?"])]
    (if (= r "Where's the restroom?")
        (say "You can pee in your pilot suit; isn't"
             "technology amazing? Built-in"
             "waste recyclers.")
        (= r "What are you doing?")
        (do (say "Well... I got a bit flustered and"
                 "forgot my password, and now I'm"
                 "locked out of the system!")
            (set convos.Adam all.Adam25)
            (all.Adam25)))))

(fn all.Adam25 []
  (say "I really need to get a tactical"
       "analysis of the beast so I'm"
       "prepared to lead the team and"
       "be the head.")
  (let [r2 (ask "" ["Why do you need to be the head?"
                    "I think I can help with the analysis."])]
    (if (= r2 "Why do you need to be the head?")
        (adam-mention-turk)
        (= r2 "I think I can help with the analysis.")
        (do (reply "I noticed the screen on the other"
                   "side of the room is already showing"
                   "the tactical analysis. Does that"
                   "have what you need?")
            (say "Oh, that might do it! Let me check.")
            (move-to :Adam 48 32 109 32 109 24)
            (set convos.Adam all.Adam3)))))

(fn all.Adam3 []
  (when (not events.adam-screen)
    (reply "How's that look?")
    (say "Perfect; thanks! Guess I don't"
         "need to log in after all.")
    (set events.adam-screen true))
  (say "The important thing for this battle"
       "is that we form up to make"
       "Rhinocelator. Otherwise we don't"
       "stand a chance on our own.")
  (say "Good thing I'm here to save the day!")
  (reply "What's that supposed to mean?")
  (when (not events.adam-mentions-turk)
    (adam-mention-turk))
  (set convos.Adam all.Adam4)
  (all.Adam4))

(fn all.Adam4 []
  (say "Remember last time Turk formed"
       "the head? You don't want a"
       "repeat of that, do you?")
  (let [r (ask "" ["Good point."
                   "Just let Turk do it already."
                   "Turk's not the only option you know."])]
    (if (= r "Just let Turk do it already.")
        (say "I really don't think that's"
             "a good idea.")
        (= r "Turk's not the only option you know.")
        (do
          (reply "Carrie is perfectly capable of"
                 "forming the head. She's smarter"
                 "than you give her credit for.")
          (say "I don't know... maybe that's true, but"
               "Turk won't see it that way. If I don't"
               "form the head, he'll do it!")
          (reply "What if Turk agreed to let Carrie"
                 "form the head?")
          (say "Huh... yeah, that could work. I mean,"
               "as long as you can convince him."
               "I don't see how you're going to do"
               "that though.")
          (set events.adam-agreed true)
          (set convos.Adam (partial describe
                                    "He's examining tactical data."))))))

;; TURK

(fn all.Turk []
  (say "Did you hear that? We got company!"
       "This is perfect; my chance to shine!")
  (say "See you in the launch bay in a few."
       "I got a couple things to do first.")
  (set convos.Turk all.Turk2)
  (move-to :Turk
           85 153
           156 153
           156 96
           179 96))

(fn turk-make-call [skip?]
  (when (not skip?)
    (say "Now if you'll excuse me, I gotta"
         "make a call.")
    (say "...")
    (say "Ugh; this station gets the worst"
         "cell reception. Maybe I can get a"
         "signal over by the airlock."))
  (move-to :Turk 180 60 164 61 164 2)
  (set convos.Turk (partial say "..."))
  (fn wait3 []
    (for [_ 1 200] (coroutine.yield))
    (set convos.Turk all.Turk3))
  (table.insert coros (coroutine.create wait3)))

(fn all.Turk2 []
  (describe "Turk seems a little agitated.")
  (reply "Hey, Turk.")
  (say "Nikita!! My favorite person. Make it"
       "quick; I've got a call with my agent"
       "in a few minutes.")
  (reply "Your agent?")
  (say "That's right. Man, I never knew being"
       "a mech pilot would be so much work!"
       "I could never keep track of all the"
       "fans and conventions on my own.")
  (say "The life of a hero is demanding!")
  (let [answer (ask "" ["I, uh, never thought of it that way."
                        "Being a pilot isn't about showing off."
                        "You're really full of yourself."])]
    (if (= answer "I, uh, never thought of it that way.")
        (do (say "Not that I'm complaining! I'm a"
                 "natural in the spotlight, but you"
                 "knew that already!")
            (turk-make-call))
        (= answer "Being a pilot isn't about showing off.")
        (do (say "Err--I mean... Sure. But why not have"
                 "a bit of fun with it if you can?")
            (describe "He flashes a wide grin.")
            (turk-make-call))
        (= answer "You're really full of yourself.")
        (do (say "Who asked you?")
            (set events.turk-annoyed true)
            (say "Anyway, I gotta go make this call.")
            (turk-make-call true)))))

(fn all.Turk3 []
  (say "Well that was a disaster.")
  (reply "What happened?")
  (say "My agent was supposed to land me a"
       "sweet merchandising deal! T-shirts,"
       "breakfast cereal... but mostly"
       "action figures; kids love those!")
  (say "But apparently I don't have enough"
       "\"star power\", whatever that means.")
  (say "It's because Adam keeps forming the"
       "head instead of me!")
  (set convos.Turk all.Turk4)
  (all.Turk4))

(fn all.Turk4 []
  (say "Now how am I going to pay off my" "student loans?")
  (describe "You recall that mech pilot school"
            "was not particularly affordable.")
  (let [answer (ask "" ["I dunno; that sucks."
                        "Maybe Hank can help."
                        "Maybe Carrie can help."])]
    (if (= answer "Maybe Hank can help.")
        (do (say "You think so?")
            (reply "Well, he's good with finances.")
            (say "Yeah, I'll talk to him.")
            ;; TODO: uuuhuhhhhhh ... yeah. fill this out more.
            (set events.turk-agreed true))
        (and (= answer "Maybe Carrie can help.") events.turk-annoyed)
        (say "I don't know if Carrie likes me"
             "all that much.")
        (= answer "Maybe Carrie can help.")
        (do (say "Well, maybe. I'll talk to her.")
            ;; TODO: uh........h.hhh...
            (set events.turk-agreed true)))))

;; for testing; remove this:
;; (set all.Turk all.Turk2)
;; (set initial-positions.Turk [179 96])
;; (set initial-positions.Nikita [170 96])

;; HANK

(fn all.Hank []
  (if
    (>= hank-state.disposition 0)
    (if
      (has-happened :hank-has-explained-his-idea)
      (hank-conversations.follow-up-conversation)
      (do
        (say "Oh, it's you. Hi Nikita.")
        (let [answer (ask "Have I told you about my project?"
                          ["Let's hear it!" "Maybe later"])]
          (if (= answer "Let's hear it!")
            (hank-conversations.explain-idea)
            (= answer "Maybe later")
            (do
              (reply "Ah, I gotta prepare to fight the"
                     "space beast. Maybe later, okay?")
              (say "Sure!"))))))
    (< hank-state.disposition 0)
    (if
      (has-happened :nikita-talked-to-pissed-off-hank)
      (if (has-happened :nikita-shit-on-hanks-idea)
        (reply "Ha, I better leave him alone.")
        (reply "I better leave him alone."))
      (do
        (publish {:event :nikita-talked-to-pissed-off-hank})
        (reply "Hank?")
        (say "...")
        (describe "He's ignoring you.")))
    (events.nikita-frustrated-hank)
    (if (events.nikita-talked-to-frustrated-hank)
      (if (events.nikita-shit-on-hanks-idea)
        (reply "Haha, I better leave him alone.")
        (reply "I better leave him alone."))
      (do
        (set events.nikita-talked-to-frustrated-hank true)
        (say "Look, I'm not in the mood to talk, okay?")))))


(fn hank-conversations.explain-idea []
  (say "Check it out!")
  (do
    (move-to :Hank 264 2)
    (move-to :Nikita 276 8))
  (say "I built a new targeting system for"
       "Rhinocelator! It utilizes machine"
       "learning algorithms and block chain"
       "validation!")
  (say "It works by applying pytorch nets"
       "to mainframe databases through a"
       "triangulated Thoralin pipe!")
  (reply "...oh, nice!")
  (describe "You nod with...|'understanding'")
  (say "We have a chance to revolutionize"
       "mech combat here. Our next mission is"
       "the ideal opportunity to perform"
       "research and install it!")
  (say "With a little effort, I believe our"
       "damage output will increase by"
       "at least 57%!")
  (let [answer
        (ask "What do you think?"
             ["Well..." "Great idea!" "Thoralin pipe?" "What a crock."])]
          (if (= answer "Thoralin pipe?")
              (hank-conversations.ask-more-about-idea)
              (= answer "Great idea!")
              (hank-conversations.support-idea)
              (= answer "Well...")
              (do
                (reply "Well.. I'm not so sure.")
                (say "What do you mean you're not"
                     "sure?")
                (reply "I'm not sure if you've noticed,"
                       "but I think Earth might be under"
                       "attack or something.")
                (reply "Something about space beasts"
                       "and warnings?")
                (hank-conversations.do-not-support-idea))
              (= answer "What a crock.")
              (do
                (publish {:event :nikita-shit-on-hanks-idea})
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
                ["Yeah!" "It's not practical."])]
    (if (= answer "Yes")
      (hank-conversations.support-idea)
      (= answer "It's not practical.")
      (do
        (reply "Hank, I think it's a good idea"
               "but I'm not really sure how"
               "practical it is.")
        (hank-conversations.do-not-support-idea)))))

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
  (say "This idea is what's best for our"
       "team even if the others can't"
       "see that.")
  (say "It is illogical to think this idea"
       "*wouldn't* work, but I suppose some"
       "folks in this world just don't"
       "understand...")
  (say "...|*especially* Carrie! She has"
       "contested this idea from the start.")
  (let [answer (ask ""
        ["What the hell?" "Hey now." "Agreed." "..."])]
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
                      "|He glares through you.")
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
          (= answer "Agreed.")
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

(fn hank-conversations.do-not-support-idea []
  (publish {:event :didnt-support-hanks-idea}
           {:event :hank-has-explained-his-idea})
  (say "Ugh, I should have known you would"
       "not support me. ...just like"
       "everyone else.")
  (let [questions ["Reassure him" "Present Facts" "Of course I don't support you" "..."]
        nikita-is-mean (has-happened :nikita-shit-on-hanks-idea)
        _ (when nikita-is-mean (table.remove questions 1))
        answer (ask "" questions)]
        (if (= answer "Reassure him")
            (do
              (update-hank-disposition 1)
              (reply "No, no, Hank, it's a good idea!"
                     "I didn't mean to poopoo in your"
                     "lunch box. Believe me, I would"
                     "love to see this get off the"
                     "ground!")
              (reply "I just have a few reservations;"
                    "that's all.")
              (describe "He won't show it, but he appreciated"
                        "that.")
              (hank-conversations.present-facts))
            (= answer "Present Facts")
            (hank-conversations.present-facts)
            (= answer "Of course I don't support you")
            (do
              (update-hank-disposition -1)
              (reply "Why would I support you? We all"
                    "know block chain and machine"
                    "learning is an overhyped mess"
                    "perpetuated by Silicon Valley"
                    "anyway.")
              (reply "And to think you'd fall for"
                     "buzzword bingo!| Ha!")
              (say "...I don't understand why you find"
                   "being a jerk so appealing.")
              (describe "He shakes his head.")
              (move-to :Hank 303 8))
            (= answer "...")
            (do
              (update-hank-disposition -1)
              (reply "...")
              (say "Fine. Don't say anything.")
              (describe "Hank scoffs.")
              (move-to :Hank 303 8)))))

(fn hank-conversations.present-facts []
  (do
    (reply "You're a smart guy. Let's take a look"
           "at your data so I can show you"
           "my concerns.")
    (do
      (move-to :Hank 289 14)
      (move-to :Nikita 302 8))
    (reply "You mentioned machine learning"
           "algorithms to generate the"
           "Thoralin pipe, right?")
    (if nikita-is-mean
      (do
        (reply "Like I was saying, we would need"
               "millions of samples for the"
               "Thoralin pipe to be effective.")
        (reply "Which upon analysis of your data"
               "|...you clearly don't have.")
        (describe "Hank frowns."))
      (do
        (reply "I only see a few hundred samples"
               "here to teach your Thoralin pipe"
               "how to triangulate.")
        (reply "Don't we need thousands or even"
               "millions of samples to train"
               "the model effectively?")
        (say "Well..for optimum performance,"
             "I suppose, but-")))
    (reply "Without proper training, we can't"
           "be certain of the Thoralin pipe's"
           "durability under stress.")
    (if nikita-is-mean
      (reply "If it collapses, then we obviously"
             "have bigger problems.")
      (reply "If it collapses, then we would have"
             "bigger problems, right?"))
    (say "Okay, but-")
    (reply "And last I talked to Carrie, we"
           "don't even have a failover"
           "plumbus set up in half the suits,"
           "so, even these projected numbers"
           "carry a high risk.")
    (if nikita-is-mean
      (reply "Your idea sucks and you should" "know better.")
      (reply "Look, I'm not saying it's a bad idea."
             "I just think we need to proceed"
             "with some caution."))
    (if (>= hank-state.disposition 2)
      (hank-conversations.willing-to-negotiate)
      (if nikita-is-mean
        (do
          (say "You're an idiot.")
          (update-hank-disposition -1)
          (move-to :Hank 303 8))
        (do
          (say "Say what you wanna say, but I"
               "have complete confidence in my"
               "data.")
          (say "I already have at least"
               "one thousand, three-hundred and"
               "thirty-seven datasets that I"
               "collated myself!")
          (say "Now if you'll kindly leave me"
               "alone.")
          (update-hank-disposition -1))))))

(fn hank-conversations.willing-to-negotiate []
  (say "Okay, Nikita. Say you're not wrong."
       "What do you recommend we do here?")
  (let [answer (ask "" ["Experiment in your own time"
                        "Let's try later"
                        "Let's gather test data"])]
    (if
      (= answer "Experiment in your own time")
      (do
        (publish {:event :nikita-frustrated-hank})
        (reply "Hank, our lives are at stake."
               "I love the fact that you are eager"
               "to improve our systems, but you"
               "should experiment in your"
               "own time.")
        (say "But this will benefit us all! It could"
             "even *save* our lives!")
        (reply "Hank. Seriously. Now is not"
               "the time.")
        (describe "Frustrated, he lets out a massive"
                  "sigh and turns his back to you.")
        (move-to :Hank 264 16))
      (= answer "Let's try later")
      (do
        (publish {:event :nikita-frustrated-hank})
        (reply "You've got a great idea here, Hank."
               "But now is not the time. We need"
               "stability.")
        (reply "Why don't we try again another time?")
        (say "We *always* put off my ideas. And I'm"
             "getting tired of it! This team, once"
             "again, fails to understand me.")
        (describe "He turns around before you can"
                  "say anything."))
      (= answer "Let's gather test data")
      (do
        (reply "You have a kick-ass idea, Hank!"
               "But I think we may have a more"
               "reasonable approach to this.")
        (reply "What if we run your system in"
               "parallel with our existing system,"
               "gather telemtry, then present this"
               "to the team?")
        (reply "This gives us a guarantee of whether"
               "or not your idea is solid.|"
               "And we both know it is.")
        (reply "So not only do we minimize our risk"
               "for this mission, but we get data"
               "to back your idea up for our next"
               "mission!")
        (say "Hm.|| I wish I could disagree, but"
             "unfortunately,|you have a compelling"
             "argument.|"
             "Better safe than sorry.")
        (say "If you can help me convince"
             "Carrie, I think we've got a plan.")
        (reply "Great! I'll chat with her and see"
               "what she thinks.")
        (reply "Thanks for hearing me out, Hank."
               "Keep the good ideas coming!")
        (describe "He flashes a wry smile, then returns"
                  "to his work."
                  "|"
                  "Way to compromise, girl.")
        (set events.hank-is-willing-to-compromise true)
        (reply "Oh, and Hank, one more thing.")
        (hank-conversations.advocate-for-carrie "What's that?")))))

(fn hank-conversations.supported-hanks-idea-follow-up []
  (if
    (not (or
           events.nikita-agreed-to-convince-carrie-of-hanks-plan
           events.nikita-frustrated-hank))
    (do
      (say "Hey Nikita! Good to see you."
           "I've got a request.")
      (reply "Oh?")
      (say "I know you like my idea, but if"
           "we have any chance of success, we"
           "need to convince Carrie.")
      (let [answer (ask "Can you give it a shot?"
                        ["I'll do my best." "I changed my mind."])]
        (if
          (= answer "I'll do my best.")
          (do
            (say "I knew I could count on you!")
            (set convos.Carrie carrie-conversations.hub)
            (set events.nikita-agreed-to-convince-carrie-of-hanks-plan true))
          (= answer "I changed my mind.")
          (do
            (reply "I'm not so sure any more Hank."
                   "I better not.|I'd prefer to sit"
                   "this one out.")
            (say "I don't understand; I thought you"
                 "supported me?")
            (reply "I do! I just like you both and I'd"
                   "rather not get in the middle of this.")
            (say "Alright, fine.| Whatever.")
            (set events.nikita-frustrated-hank true)
            (move-to :Hank 264 16))))))
    (events.nikita-agreed-to-convince-carrie-of-hanks-plan)
    (if
      (events.carrie-rejects-hanks-plan)
      (do
        (say "Hey Nikita! Any news?")
        (reply "No good news, I'm afraid.")
        (say "...what did she say?")
        (reply "Well, in no shortage of bad words,"
               "she rejected your idea.")
        (say "...great. Why am I not surprised?"
             "Thanks for trying.")
        (set events.nikita-frustrated-hank true)
        (move-to :Hank 264 16))
      (do
        (say "Hey Nikita. Any word from Carrie?")
        (reply "Not yet; I'll keep you posted."))))

(fn hank-conversations.follow-up-conversation []
  (if
    (has-happened :supported-hanks-idea)
    (hank-conversations.supported-hanks-idea-follow-up)
    (has-happened :carrie-accepts-hanks-compromise)
    (do
      (say "Any news?")
      (reply "Actually, yeah! Great news! Carrie"
             "is on board!")
      (say "That's great!! Thank you for finding"
           "this compromise, Nikita. I owe you one.")
      (reply "It's no problem. I look forward to"
             "seeing your progress!")
      ;; TODO SFX?
      (describe "Your high five with Hank shattered"
                "a window somewhere.")
      (say "...|And you know what? It will be good for"
           "Carrie to be head. She's gonna do great!")
      (say "Anyway, I better get to work! No time to"
           "waste!")
      (set events.hank-agreed true)
      (move-to :Hank
               247 17
               247 51
               180 51
               158 108
               158 154
               226 154

               229 194)
      (set convos.Hank hank-conversations.installing-telemetry)
    (hank-conversations.advocate-for-carrie))))

(fn hank-conversations.advocate-for-carrie [greeting-override]
  (let [greeting
         (if
           (greeting-override) greeting-override
           (events.nikita-agreed-to-convince-carrie-of-hanks-compromise) "Any news?"
           "Greetings. How can I help?")
        questions []
        _ (if (not events.nikita-agreed-to-convince-carrie-of-hanks-compromise)
            (do
              (table.insert questions "Carrie should be the head")
              (table.insert questions "Nevermind."))
            (table.insert questions "Nothing yet."))
        answer (ask greeting questions)]
      (if
        (= answer "Carrie should be the head")
        (do

          (reply "Soo, hey.| I think Carrie should be"
                 "the head for this next fight.")
          (reply "She's always overlooked by the rest"
                 "of us, but we both know she's"
                 "more than capable as a leader.")
          (reply "Especially since Adam and Turk tend"
                 "to butt heads, it would be a nice"
                 "change of pace. She deserves a shot.")
          (reply "What do you think?")
          (if events.hank-is-willing-to-compromise
            (do
              (say "...|Honestly, I like that idea.")
              (say "If you can get her to back your"
                   "idea so we can gather data for"
                   "the targeting system, I'm on board.")
              (set convos.Carrie carrie-conversations.hub)
              (set events.nikita-agreed-to-convince-carrie-of-hanks-compromise
                   true))
            (do
              (say "I disagree. I know Carrie doesn't"
                   "support my idea and you've"
                   "made it clear that you don't either..")
              (say "...so why would I support this?")
              (reply "Come on, Hank.")
              (say "Sorry.| You won't get my support.")
              (describe "He returns to his work.")
              (set convos.Hank hank-conversations.busy))))
          (= answer "Nevermind.")
          (describe "Hank nods and returns to his work.")
          (= answer "Nothing yet.")
          (reply "Well, keep me posted."))))

(fn hank-conversations.busy []
  (say "I'm busy. I'd rather not talk right now."))

(fn hank-conversations.installing-telemetry []
  (describe "The clattering of keys, levers, and"
            "beeps indicates Hank is going ham"
            "on his software.")
  (reply "Better leave him to it."))

;;
;; CARRIE
;;

(fn all.Carrie []
  (if (= :hank last-losing)
      (say "I hope we can run just a normal"
           "mission without it turning into"
           "some half-baked plan.")
      (. {:adam-turk true :adam true :turk true} last-losing)
      (say "If only Turk and Adam would stop"
           "fighting over who gets to be"
           "the head.")
      :else
      (do
        (say "Uh oh, not another space beast.")
        (reply "Are you worried?")
        (say "It's just that... we haven't been"
             "working together as a team very"
             "well recently.")
        (say "We got lucky in our last battle when"
             "MegaMoth ran into that huge solar" "collector.")
        (say "But if we fail to form Rhinocelator"
             "again this time...")))
  (say "Well, I better get my gear.")
  (move-to :Carrie 142 302)
  (set convos.Carrie carrie-conversations.looking-for-helmet))

(fn carrie-conversations.hub []
  (let [questions []]
    (when (and
            events.nikita-agreed-to-convince-carrie-of-hanks-plan
            (not events.carrie-rejects-hanks-plan))
      (table.insert questions "Hank has a new targeting system."))
    (when (and
            events.nikita-agreed-to-convince-carrie-of-hanks-compromise
            (not events.carrie-accepts-hanks-compromise))
      (table.insert questions "Have you heard about Hank's plan?"))
    (if
      (not events.carrie-found-her-helmet)
      (do
        (reply "Hey Carrie, I have-")
        (move-to :Carrie 119 304)
        (say "One sec, Nikita..")
        (describe "She grunts as stretches her arm"
                  "under the bed.")
        (say "|...|...got it!")
        (say "I have no idea how my helmet ended"
             "there..|Anyway! You have my attention.")
        (say "How can I help?")
        (set events.carrie-found-her-helmet true)
        (table.insert questions "Nevermind"))
      (do
        (if events.nikita-has-talked-to-carrie
          (do
            (describe "She's reviewing the owner's manual"
                      "for her mech. She looks up and"
                      "smiles.")
            (set events.nikita-has-talked-to-carrie true))
          (describe "She's reviewing the owner's manual"
                    "for her mech..|Again. She looks up."))
        (say "Hey Nikita! Shouldn't you be getting"
            "ready?")
        (table.insert questions "Good point")))
    (let [answer (ask "" questions)]
      (if
        (= answer "Nevermind")
        (do
          (reply "Ah, nevermind Carrie. I'll get"
                 "out of your hair!")
          (say "Well, you know my office hours.")
          (describe "She flashes you a corny smile"
                    "and picks up her owner's manual."))
        (= answer "Good point")
        (do
          (reply "Good point. I'll leave you to it.")
          (say "Well, you know my office hours.")
          (describe "She flashes you a corny smile"
                    "and picks up her owner's manual."))
        (= answer "Hank has a new targeting system.")
        (carrie-conversations.convince-carrie-of-hanks-plan)
        (= answer "Have you heard about Hank's plan?")
        (carrie-conversations.convince-carrie-of-hanks-compromise)))))

(fn carrie-conversations.convince-carrie-of-hanks-plan []
  (reply "So Hank has a new targeting system.")
  (describe "She rolls her eyes.")
  (say "So I've heard. Did he try convincing you"
       "as well?")
  (reply "Well he did, actually. Look, even a 25%"
         "improvement to our damage output could"
         "give us an edge in this battle. Even"
         "Adam can't do that much damage.")
  (say "...|Are you serious? We're going"
       "into battle,| where we could *die*,"
       "|and you both want to gut our targeting"
       "systems for an experiment?"
       "I can't support that.")
  (reply "But-")
  (say "Come on! You know this isn't the right"
       "time for trying new systems. We can't"
       "risk it!")
  (reply "Please reconsider. I really think-")
  (say "Sorry, but the answer is no, Nikita."
       "Tell him we can try after this battle,"
       "but it really doesn't make sense.")
  (describe "She shakes her head a bit and"
            "turns around.")
  (set events.carrie-rejects-hanks-plan true))

(fn carrie-conversations.convince-carrie-of-hanks-compromise []
  (reply "You've heard of Hank's new targeting system,"
         "right?")
  (describe "She rolls her eyes.")
  (say "*sigh*" "Who hasn't?")
  (say "Sometimes his dedication to innovation"
       "goes a little too far...")
  (reply "I know what you mean, but I think he"
         "might be onto something here.")
  (reply "And! He agreed to let you form the"
         "head in our next battle if you're"
         "interested.")
  (describe "She perks up.")
  (say "Me? As the head? I mean, as Captain"
       "Talroth says in 'Star Adventures',"
       "'Count me the hell in!', but I"
       "could never agree to it at the expense"
       "of our team or our mission.")
  (reply "That's admirable! But I think we can"
         "accomplish both.")
  (say "I'm listening.")
  (reply "So I agree it's not the right time"
         "to deploy these new systems, but"
         "I have an idea for compromise.")
  (reply "What if we install his systems in"
         "an observation capacity, only?"
         "Our systems would remain unaffected,"
         "but we could gather telemtry on his"
         "systems in the meantime.")
  (reply "Once we make it through a battle"
         "or two, then we can sit down and"
         "evaluate it as a team.")
  (reply "In my opinion, it's low risk"
         "with a lot of reward? What do you"
         "say?")
  (describe "Her eyes narrow in thought.")
  (say "...|Why not? I'm game."
       "Tell him I'm on board!")
  (reply "That's awesome! I'll tell him"
         "right now. Thanks for listening!")
  (say "Of course.")
  (move-to :Nikita 105 301)
  (say "And Nikita?||"
       "...thanks for advocating for me."
       "You're a good friend.")
  (describe "She smiles softly and returns"
            "to her manual.")
  (set events.carrie-accepts-hanks-compromise true))

(fn carrie-conversations.looking-for-helmet []
  (say "Now where did I put my helmet?")
  (set convos.Carrie carrie-conversations.observe-search-for-helmet))

(fn carrie-conversations.observe-search-for-helmet []
  (say "..grr, dang it!")
  (let [random (math.ceil (* (math.random) 1000))]
    (if (= 0 (% random 2))
      (move-to :Carrie 141 315)
      (move-to :Carrie 149 288)))
  (describe "She apparently hasn't found her"
            "helmet yet..")
  (move-to :Carrie 142 302))

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
  (set poster-count (+ poster-count 1)) ; allow cheating after six counts
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

(set chars.door1 {:x 56 :y 160})
(set chars.door2 {:x 106 :y 231})
(fn all.door1 [] (describe "Locked."))
(set all.door2 all.door1)

(set chars.airlock {:x 162 :y -14})
(fn all.airlock []
  (describe "It's an airlock. Better not" "open it."))
