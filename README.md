# this is MY mech

A giant space worm is attacking Earth!

The heroes of Rhinocelator are summoned to protect the planet.

Problem is, they can't really get their act together.

https://m.youtube.com/watch?v=EMgsAD3D948

## Characters

### ADAM Goldman (Gold Rhino)

Thinks he should be the head because he thinks he's got the best
attacks and the best ideas, and therefore he deserves to tell everyone
what to do. Major white privilege tech-bro thing going on. Thinks he's
a "leader" but only leads because everyone else eventually gets tired
of arguing with him and lets him win.

### TURK Bragg (Turquoise Rhino)

Hugely narcissistic. Loves to be in the spotlight and really enjoys
the attention of the fans, who he'll do anything for. His priority is
looking good on camera and gaining fans.

### HANK Rogers (Pink Rhino)

NASA-trained astrophysicist pilot. Not as pushy as the first two, but
pretty resentful that his brilliance isn't acknowledged. He wants to
replace the targeting system with a new machine-learning blockchain
system he has been working on, even though the existing targeting
system works fine.

### CARRIE Hayes (Purple Rhino)

Patient and intelligent but consistently overlooked by her brash
teammates. She is very talented but has gotten used to just keeping
quiet to avoid trouble.

### Player character (Black Rhino)

This is you! We don't have to write characterization for the
protagonist because their choices are the player's choices; isn't that
convenient?

## Plot

You start on the base in orbit around Earth and the alarm is going
off. You leave your room and try to see what's going on. By talking to
the other pilots you learn that there is an attack on Earth and that
you must defend it with your rhino-mech.

If you allow the events to proceed normally, the rhinos launch to
attack the enemy but cannot join up to form Rhinocelator because they
can't agree who will form the head, so the team is defeated.

You have to talk to Adam, Turk, and Hank and convince each of them
that it's time to give Eve a turn leading the group. Finally you have
to talk to Eve as well to convince her that she has what it takes to
lead the team to victory.

## Gameplay

The game plays out as an adventure game where you walk around the base
and interact with the other 4 characters. We'll need collision
detection and a dialog-tree system.

Once you launch the rhino-mechs, it switches to flight mode where you
can fly your mech around and blast the space worm. However, your
attacks have no impact on it, and eventually it destroys you if you
don't form Rhinocelator.

The expectation is that you'll lose the game several times and have to
restart before you figure out the right path to victory. Because of
this, we should find a way to make it so that losing is actually kind
of funny and doesn't feel like such a bummer.

## Setting

The Rhinocelator home base space station.

* Bridge
* Quarters
* Launch bay
* Mess hall?
* Repair bay?

## Art

* Character sprites for each of the 5 pilots (palette-swaps?)
* Portraits for the 4 NPCs
* Space base background tiles
* Sprites for the rhino-mechs (palette-swaps)
* Space worm thing, with attacks
* Rhinocelator, with assemble animation
* Start screen
* Win screen

## Music

* Base
* Flight
* Losing
* Winning

## Sound effects

* Launch
* Firing weapon
* Hit by attack
* Form Rhinocelator
* Doors in the base?

## Writing

We need to come up with how the conversations go among the different
characters. Obviously the only winning condition is when Eve is the
head, which can only happen when all three of the other pilots agree
not to try to be the head.

We can model this as three separate "convinced" flags, but that feels
overly simplistic. We can distract from the fact that it's just flags
by modeling some interaction between them. For instance, you only
realize that Hank will try to take over if you launch after convincing
Adam and Turk.

## End states

### Convincing no one

* Adam and Turk just bicker over who's going to form the head
* Hank makes sarcastic comments
* Eve tries to get them to stop fighting but can't

### Convincing Adam

...

### Convincing Turk

### Convincing Hank

### Convincing Adam and Turk

### Convincing Turk and Hank

### Convincing Adam and Hank
