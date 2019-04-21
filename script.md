# Turk

"Look, for all intensive purposes, I'm screwed here!"

# Hank

- _`IF DISPOSITION >= 0`_
  * -> Intro
- `ELSE IF DISPOSITION < 0`
  * He ignores you: "..."
  * -> End
- `WHEN STUBBORN OR WHEN CARRIE DISAGREES WITH PLAN`
  * "I'm not in the mood to talk, okay?"
  * -> End

## Intro
* Wants to use machine learning with block chain validation for a new
  targeting system
  * _Ask more_ `ADD ONE DISPOSITION`
    * Get explanation
      * _Disagree_
        * -> No Support
      * Back his idea
        * -> Support
  * Back his idea
    * -> Support
  * Don't Support
    * -> No Support
  * Harsh Don't Support `MINUS ONE DISPOSITION`
    * -> No Support
- `WHEN BLOCKCHAIN CONVO OVER`
  * Suggest Carrie Be Head
    - _`IF NO SUPPORT HANK`_
      * _`AND DISPOSITION >= 2`_
        * Agrees to back Carrie `SET CONVINCE CARRY OF HANKS PLAN`
      - `AND DISPOSITION < 2`
        - `AND REQUESTED CARRIE BEFORE`
          * Disagrees again
        - `ELSE`
          * Disagree
    - `IF SUPPORT HANK`
      * `SET CONVINCE CARRY OF HANKS PLAN` (This won't work because Hank won't budge)
      * "I know you're on my side. If you can convince Carrie on my tech, sure."
      * -> Exit
- `WHEN CARRIE CONVINCED OF HANK'S COMPROMISE`
  * Excitement! `SET HANK SUPPORTS CARRIE`

### Support
* Gets amped up with your support
  * Scorns Carrie's rejections
    * Defend Carrie Lightly `SET NO SUPPORT HANK` `SET BLOCKCHAIN CONVO OVER`
      * Apathetic dismissal
      * -> End
    * Defend Carrie Harshly `MINUS TWO DISPOSITION` `SET NO SUPPORT HANK` `SET BLOCKCHAIN CONVO OVER`
      * Accuses you of being dishonest
      * -> End
    * Go along with rejection `SET SUPPORT HANK` `SET BLOCKCHAIN CONVO OVER`
      * -> Support Hank
    * Silence `SET SUPPORT HANK` `SET BLOCKCHAIN CONVO OVER`
      * -> Support Hank

### No Support
* Feels defensive that you don't believe in his idea
  * _Reassure him_ `ADD ONE DISPOSITION` `REMOVE SELF`
    * -> No Support
  * Present facts
    - `IF DISPOSITION > 2`
      * _Realizes that he's wrong, but can't admit it_
      * -> Willing to Negotiate
    - `ELSE`
      * Annoyed and won't listen to reason. `MINUS ONE DISPOSITION`
      * -> End
  * Poke fun `MINUS ONE DISPOSITION`
    * -> End
  * Silence `MINUS ONE DISPOSITION`
    * -> End

## Willing to Negotiate
* Dismiss idea: "You can do it in your own time"
  * Feels dismissed `SET STUBBORN` `SET BLOCKCHAIN CONVO OVER`
  * -> End
* We can try later
  * Feels dismissed `SET STUBBORN` `SET BLOCKCHAIN CONVO OVER`
  * -> End
* _Try prototyping_
  * This is a good idea! "Maybe I was was a bit overzealous..."
  * `SET BLOCKCHAIN CONVO OVER`
  * -> End


# Carrie

## Intro
- `IF CONVINCE CARRIE OF HANK'S COMPROMISE`
  * Agree. `SET CARRIE CONVINCED OF HANK'S COMPROMISE`
  * -> END
- `IF CONVINCE CARRIE OF HANK'S PLAN`
  * Expresses bewilderment
    * "And you supported that? I'm surprised."
      * Agree with Hank. `SET CARRIE DISAGREES WITH HANK'S PLAN`
        * -> END
      * Agree with Carrie. `SET CARRIE DISAGREES WITH HANK'S PLAN`
        * -> END
