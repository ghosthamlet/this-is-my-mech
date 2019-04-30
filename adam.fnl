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

(fn all.Adam2 [skip-sorry?]
  (when (not skip-sorry?) (say "Hey, sorry about that."))
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
          (set convos.Adam all.Adam5)
          (all.Adam5)))))

(fn all.Adam5 []
  (reply "What if Turk agreed to let Carrie"
    "form the head?")
  (say "Huh... yeah, that could work. I mean,"
    "as long as you can convince him."
    "I don't see how you're going to do"
    "that though.")
  (set events.adam-agreed true)
  (when events.turk-agreed
    (reply "Actually Turk has already agreed.")
    (say "Really? Well, in that case it works" "for me.")
    (say "I better go get ready!")
    (move-to :Adam 109 59 158 59 158 157 225 157 233 126)
    (set convos.Adam (partial describe "He's preparing for launch."))))
