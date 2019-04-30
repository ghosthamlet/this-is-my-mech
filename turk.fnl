(fn all.Turk []
 (say "Did you hear that? We got company!"
  "This is perfect; my chance to shine!")
 (say "See you in the launch bay in a few."
  "I got a couple things to do first.")
 (set convos.Turk all.Turk2)
 (move-to :Turk 85 153 156 153 156 96 179 96))

(fn turk-make-call [skip?]
  (when (not skip?)
    (say "Now if you'll excuse me, I gotta"
         "make a call.")
    (when (not prev-events.turk-called)
        (say "...|Hello?"
             "|"
             "...|HEEELLO!?")
        (say "Tay, are you THERE!?")
        (say "Ugh; this station gets the worst"
             "cell reception. Maybe I can get a"
             "signal over by the airlock.")))
  (set events.turk-called true)
  (move-to :Turk 180 60 164 61 164 2)
  (set convos.Turk (partial say "..."))
  (fn wait3 []
    (for [_ 1 200] (coroutine.yield))
    (set convos.Turk all.Turk3))
  (table.insert coros (coroutine.create wait3)))

(fn all.Turk2 []
 (describe "Turk seems a little agitated.")
 (reply "Hey, Turk.")
 (when (not prev-events.turk-called)
  (say "Nikita!! My favorite person. Make it"
   "quick; I've got a call with my agent"
   "in a few minutes.")
  (reply "Your agent?")
  (say "That's right. Man, I never knew being"
   "a mech pilot would be so much work!"
   "I could never keep track of all the"
   "fans and conventions on my own."))
 (say "The life of a hero is demanding!")
 (let [answer (ask "" ["I, uh, never thought of it that way."
                       "Being a pilot isn't about showing off."
                       "Wow, pretentious much?"])]
  (if (= answer "I, uh, never thought of it that way.")
   (do (say "Not that I'm complaining! I'm a"
        "natural in the spotlight, but you"
        "knew that already!")
    (describe "...|BARF!")
    (turk-make-call))
   (= answer "Being a pilot isn't about showing off.")
   (do (say "Err--I mean... Sure. But why not have"
        "a bit of fun with it if you can?")
    (describe "He flashes a wide grin.")
    (turk-make-call))
   (= answer "Wow, pretentious much?")
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
  (set convos.Turk all.Turk-hub)
  (all.Turk-hub))

(fn all.Turk-refuse []
  (say "I don't need any help.")
  (say "Turk Tucker has never failed" "himself."))

(fn all.Turk-hub [skip-intro?]
  (if (not skip-intro?)
   (do (say "Now how am I going to pay off my" "student loans?")
       (describe "You recall that mech pilot school"
        "was not particularly affordable."))
   (say "What am I going to do!?" "For all intensive purposes," "I'm screwed!"))
 (let [questions ["That sucks." "Maybe Hank can help."]
       _ (if (and events.hank-agrees-to-help-turk)
          (tset questions 2 "So I caught up with Hank.")
          events.turk-says-he-will-talk-to-hank
          (tset questions 2 "Have you talked to Hank yet?"))
       _ (when skip-intro? (table.remove questions 1))
       answer (ask "" questions)]
  (if (= answer "That sucks.")
   (do
    (if events.turk-annoyed
     (say "Yeah.| It does.")
     (say "Yeah, it does Nikita! Why do"
      "only bad things happen to me?"))
    (set convos.Turk (partial all.Turk-hub true)))
   (= answer "Maybe Hank can help.")
   (do (say "You think so?")
    (reply "Well, he's good with finances.")
    (reply "He's the reason we could"
     "re-finance two of our-")
    (say "Yeah, yeah, I'll talk to him."
     "Thanks a bunch!")
    (set convos.Turk (partial all.Turk-hub true))
    (set events.turk-says-he-will-talk-to-hank true)
    (set events.turk-agreed true))
   (= answer "So I caught up with Hank.")
   (do
    (say "Oo, what did he say!?")
    (reply "He said he'll help you, but only"
     "if Carrie will back his new"
     "targeting system.")
    (say "Delightful!|...|wait.")
    (say "Did you say new targeting system?")
    (reply "Well, yeah.")
    (say "Great."
     "|"
     "I won't hold my breath.")
    (say "Guess I'll have to solve my"
     "own problems. No problem is"
     "too big for me!")
    (set convos.Turk all.Turk-refuse))
   (= answer "Have you talked to Hank yet?")
   (do
    (say "Nooo..I haven't found a chance."
     "Could you go and talk to him"
     "for me!?")
    (reply "Bu-")
    (say "Kay, thaaaaanks!")
    (describe "...|...ugh!")
    (set events.nikita-will-ask-hank-to-help-turk true)))))
