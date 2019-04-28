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
        (describe "He's ignoring you.")))))


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
    (if (= answer "Yeah!")
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
                   "just being realistic.")
            (reply "Plus you're being a bit pretentious"
                   "right now. |Cut the shit.")
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
        nikita-is-mean? (has-happened :nikita-shit-on-hanks-idea)
        _ (when nikita-is-mean? (table.remove questions 1))
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
              (hank-conversations.present-facts nikita-is-mean?))
            (= answer "Present Facts")
            (hank-conversations.present-facts nikita-is-mean?)
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

(fn hank-conversations.present-facts [nikita-is-mean?]
  (do
    (if nikita-is-mean?
      (reply "Okay dumbass, let's look at your" "data.")
      (reply "You're a smart guy. Let's take a look"
             "at your data so I can show you"
             "my concerns."))
    (do
      (move-to :Hank 289 14)
      (move-to :Nikita 302 8))
    (reply "You mentioned machine learning"
           "algorithms to generate the"
           "Thoralin pipe, right?")
    (if nikita-is-mean?
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
    (if nikita-is-mean?
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
    (if nikita-is-mean?
      (reply "Your idea sucks and you should" "know better.")
      (reply "Look, I'm not saying it's a bad idea."
             "I just think we need to proceed"
             "with some caution."))
    (if (>= hank-state.disposition 2)
      (hank-conversations.willing-to-negotiate)
      (if nikita-is-mean?
        (do
          (say "Evidently, you don't have the"
               "capacity to understand.")
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
             "unfortunately,| you have a"
             "compelling argument.|"
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
    (not events.nikita-agreed-to-convince-carrie-of-hanks-plan)
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
                   "I like you both and I don't want"
                   "to get in the middle.")
            (reply "I'd prefer to sit this one out.")
            (say "I don't understand."
                 "I thought you supported me?")
            (reply "I do!"
                   "|"
                   "I just don't want to get in the"
                   "middle of this.")
            (say "Alright, fine.| Whatever.")
            (set convos.Hank hank-conversations.frustrated-hank)
            (move-to :Hank 264 16)))))
    events.nikita-agreed-to-convince-carrie-of-hanks-plan
    (if
      events.carrie-rejects-hanks-plan
      (do
        (say "Hey Nikita! Any news?")
        (reply "No good news, I'm afraid.")
        (say "...what did she say?")
        (reply "Well, in no shortage of bad words,"
               "she rejected your idea.")
        (say "...great. Why am I not surprised?"
             "Thanks for trying.")
        (set convos.Hank hank-conversations.frustrated-hank)
        (move-to :Hank 264 16))
      (do
        (say "Hey Nikita. Any word from Carrie?")
        (reply "Not yet; I'll keep you posted.")))))

(fn hank-conversations.follow-up-conversation []
  (if
    (has-happened :supported-hanks-idea)
    (hank-conversations.supported-hanks-idea-follow-up)
    (has-happened :carrie-accepts-hanks-compromise)
    (do
      (say "Any news?")
      (reply "Actually, yeah! Great news! Carrie"
             "is down with the idea! Let's get"
             "you some data!")
      (say "That's great!! Thank you for finding"
           "this compromise, Nikita."
           "|"
           "...I owe you one.")
      (reply "It's no problem. |I look forward to"
             "seeing your progress!")
      ;; TODO SFX?
      (describe "Your high five with Hank shattered"
                "a window somewhere.")
      (say "...|And hey, I'm glad you convinced"
           "me on Carrie. She will do a great job"
           "at rallying us together.")
      (say "Anyway, I better get to work!"
           "No time to waste!")
      (set events.hank-agreed true)
      (move-to :Hank
               247 17
               247 51
               180 51
               158 108
               158 154
               226 154
               229 194)
      (set convos.Hank hank-conversations.installing-telemetry))
    (hank-conversations.advocate-for-carrie)))

(fn hank-conversations.advocate-for-carrie [greeting-override]
  (let [greeting
         (if
           greeting-override greeting-override
           events.nikita-agreed-to-convince-carrie-of-hanks-compromise "Any news?"
           "Hi, Nikita.")
        questions []
        _ (if
            (not events.nikita-agreed-to-convince-carrie-of-hanks-compromise)
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
          (say "Well, keep me posted."))))

(fn hank-conversations.busy []
  (say "I'm busy. I'd rather not talk"
       "right now."))

(fn hank-conversations.frustrated-hank []
  (if events.nikita-talked-to-frustrated-hank
      (if events.nikita-shit-on-hanks-idea
        (reply "Haha, I better leave him alone.")
        (reply "I better leave him alone."))
      (do
        (set events.nikita-talked-to-frustrated-hank true)
        (say "Look, I'm not in the mood to talk,"
             "|okay?"))))

(fn hank-conversations.installing-telemetry []
  (describe "The clattering of keys, levers, and"
            "beeps indicates Hank is going ham"
            "on his software.")
  (reply "Better leave him to it."))
