# this is MY mech

A giant space worm is attacking Earth!

The heroes of Rhinocelator are summoned to protect the planet.

Problem is, they can't really get their act together.

https://m.youtube.com/watch?v=EMgsAD3D948

Written in [Fennel](https://fennel-lang.org) using
[TIC-80](https://tic.computer). Winner of the
[2019 Lisp Game Jam](https://itch.io/jam/lisp-game-jam-2019/results).

You can [play the game in your browser](https://technomancy.itch.io/this-is-my-mech).

To run from source, install TIC-80 and run `make`. Changes to the .fnl
source files in the repository will be reloaded into the game when you
re-run it from the TIC-80 console.

Copyright © 2019 [Emma Bukacek](https://emmabukacek.com) and [Phil Hagelberg](https://technomancy.us)

Released under the GNU General Public License version 3; see the file LICENSE.

## Design notes

## Characters

### ADAM Goldman (Gold Rhino)

Thinks he should be the head because he thinks he's got the best
attacks and the best ideas, and therefore he deserves to tell everyone
what to do. Major white privilege tech-bro thing going on. Thinks he's
a "leader" but only leads because everyone else eventually gets tired
of arguing with him and lets him win.

#### Tone
Leans into buzzwords, e.g. "synergy" and "serverless," and has a penchant for
condescension. Too matter-of-fact sounding and too proud; however, shows great
concern for friends underneath his annoying bravado.

#### Song Facts
* Claims he does the most damage

### TURK Bragg (Turquoise Rhino)

Hugely narcissistic. Loves to be in the spotlight and really enjoys the
attention of the fans, who he'll do anything for. His priority is looking good
on camera and gaining fans. Unfortunately, a "guaranteed" television pilot that
he starred in was passed up by every major studio. Despite Turk's appearance of
fame and fortune, he could actually default on his properties and loans due to
mismanagement of funds without a steady job. He pretends to befine, but
ultimately, he wants to increase his brand and image by acting as the head in
the hopes of scoring more gigs to bring his life stability.

#### Tone
Cursing and easy word play. Sucker for buzzwords and pop culture. Can get real
under extreme circumstances, but tends to hide behind fame instead of dealing
with his problems. Interrupts people. He's a mumpsimus in that he uses eggcorns
and malapropisms without realizing it.

#### Song Facts
* Has an agent
* Is a star of some sort
  * Movies?
  * Television?

### HANK Rogers (Pink Rhino)

NASA-trained astrophysicist pilot. Not as pushy as the first two, but
pretty resentful that his brilliance isn't acknowledged. He wants to
replace the targeting system with a new machine-learning blockchain
system he has been working on, even though the existing targeting
system works fine. He met Carrie while working on his dissertation
(Triangulating Wronskian Block Chains to Boost Plasma Nacelles) and
together they applied to the Rhino strike team, being the first pair
ever to be accepted onto the team.

#### Tone
Has a large vocabulary and isn't afraid to use it, regardless of his audience.

### CARRIE Hayes (Purple Rhino)

Known as the engineer of the group, but is also an adept pilot. She's even a
chess grandmaster! Her intelligence, kindness, and empathy are consistently
overlooked by her brash teammates. While close to Hank and Nikita, she often
disagrees with Adam and Turk. Despite her patience, she's butted her head back a
few times, but often loses against the two. Despite her talent, she often keeps
quiet to avoid trouble.

#### Tone
Leans into idioms a lot and quotes cheesy movies. Soft spoken, but chooses
her words with care.

### NIKITA Anand (Black Rhino)

Weapons specialist of the group and amateur comedian. Sardonic as they
come and sometimes her sharpness gets her into trouble. Graduated top of
her class at the Rhino Academy, she's one of the newest to the group.
She immediately got along with Carrie, who was delighted to finally
have another woman on board. Then by extension of Carrie, Nikita
also developed a friendship with Hank. She plays into Turk's narcissism
enough to keep him off her back, but she tends to feel confined by
Adam's suffocating mentorship.


## Plot

You start on the base in orbit around Earth and the alarm is going
off. You leave your room and try to see what's going on. By talking to
the other pilots you learn that there is an attack on Earth and that
you must defend it with your rhino-mech.

If you allow the events to proceed normally, the rhinos launch to
attack the enemy but cannot join up to form Rhinocelator because they
can't agree who will form the head, so the team is defeated.

You have to talk to Adam, Turk, and Hank and convince each of them
that it's time to give Carrie a turn leading the group. Finally you have
to talk to Carrie as well to convince her that she has what it takes to
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
characters. Obviously the only winning condition is when Carrie is the
head, which can only happen when all three of the other pilots agree
not to try to be the head.

We can model this as three separate "convinced" flags, but that feels
overly simplistic. We can distract from the fact that it's just flags
by modeling some interaction between them. For instance, you only
realize that Hank will try to take over if you launch after convincing
Adam and Turk.
