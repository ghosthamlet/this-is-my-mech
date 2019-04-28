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
        (move-to :Carrie 142 302)
        (say "I have no idea how my helmet ended"
             "there..|Anyway! You have my attention.")
        (say "How can I help?")
        (set events.carrie-found-her-helmet true)
        (table.insert questions "Nevermind"))
      (do
        (describe "She's reviewing the owner's manual"
                  "for her mech. She looks up and"
                  "smiles.")
        (say "Hey Nikita! Shouldn't you be getting"
             "ready?")
        (table.insert questions "Good point.")))
    (let [answer (ask "" questions)]
      (if
        (= answer "Nevermind")
        (do
          (reply "Ah, nevermind Carrie. I'll get"
                 "out of your hair!")
          (say "Well, you know my office hours.")
          (describe "She flashes you a corny smile"
                    "and picks up her owner's manual."))
        (= answer "Good point.")
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
  (set events.carrie-rejects-hanks-plan true)
  (set convos.Hank all.Hank))

(fn carrie-conversations.convince-carrie-of-hanks-compromise []
  (reply "You've heard of Hank's new targeting system,"
         "right?")
  (describe "She rolls her eyes.")
  (say "*sigh*" "|" "Who hasn't?" )
  (say "I love the guy, but sometimes his"
       "dedication to innovation goes a"
       "little too far...")
  (reply "I know what you mean, but I think he"
         "might be onto something here.")
  (say "Ha, don't tell me he got to you!")
  (reply "Heh, a bit. |Hear me out, though.")
  (reply "If you support his idea, he even"
         "agreed to back you as the head in"
         "our next battle!")
  (describe "She perks up.")
  (say "Me?| As the head?| I mean, as Captain"
       "Talroth says in 'Star Adventures',"
       "'Count me in, please!'")
  (say "...but I could never agree to it at"
       "the expense of our team or our"
       "mission.")
  (say "His targeting system is too"
       "premature.")
  (reply "I hear you, girl, but I think we"
         "can accomplish both.")
  (say "...I'm listening.")
  (reply "So I agree it's not the right time"
         "to deploy these new systems, but"
         "I have an idea for compromise.")
  (reply "What if we install his systems in"
         "an observation capacity, only?")
  (reply "Our systems would remain"
         "unaffected, but we could gather"
         "telemtry on his systems in"
         "the meantime.")
  (reply "Once we make it through a battle"
         "or two, then we can sit down and"
         "evaluate it as a team.")
  (reply "In my opinion, it's low risk, but"
         "with a high chance of reward."
         "|"
         "What do you say?")
  (describe "Her eyes narrow in thought.")
  (say "...|Why not?| I'm game.")
  (say "Tell him I'm on board!""")
  (reply "That's awesome! I'll let him know."
         "|"
         "I appreciate you!")
  (say "Of course.")
  (move-to :Nikita 105 301)
  (say "And Nikita?"
       "||"
       "...thanks for advocating for me.")
  (say "You're a good friend.")
  (describe "She smiles softly and returns"
            "to her manual.")
  (set events.carrie-accepts-hanks-compromise true)
  (set convos.Hank all.Hank))

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
