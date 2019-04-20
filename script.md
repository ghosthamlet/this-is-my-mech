# Turk

"Look, for all intensive purposes, I'm screwed here!"

# Hank

- _`IF DISPOSITION >= 0`_
  * -> Intro
- `ELSE IF DISPOSITION < 0`
  * He ignores you
  * -> End
- `WHEN STUBBORN`
  * "I'm not in the mood to talk, okay?"
  * -> End

## -Intro
* Wants to use machine learning with block chain validation for a new
  targeting system
  * _Ask more `ADD ONE DISPOSITION`_
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
        * Agrees to back Carrie [SET HANK SUPPORTS CARRIE]
      * `AND DISPOSITION < 2`
        * `AND REQUESTED CARRIE BEFORE`
          * Disagrees again
        * `ELSE`
          * Disagree
    - `IF SUPPORT HANK AND DISPOSITION > 0`
      * -> No Support

### Support
* Gets amped up with your support
  * Scorns Carrie's rejections
    * Defend Carrie Lightly `SET NO SUPPORT HANK`
      * Apathetic dismissal
      * -> End
    * Defend Carrie Harshly `MINUS TWO DISPOSITION` `SET NO SUPPORT HANK`
      * Accuses you of being dishonest
      * -> End
    * Go along with rejection `SET SUPPORT HANK`
      * -> Support Hank
    * Silence `SET SUPPORT HANK`
      * -> Support Hank

### No Support
* Feels defensive that you don't believe in his idea
  * _Reassure him `ADD ONE DISPOSITION` `REMOVE SELF`_
    * -> No Support
  * Present facts
    - _`IF DISPOSITION > 2`_
      * Realizes that he's wrong, but can't admit it
      * -> Willing to Negotiate
    - `ELSE`
      * Annoyed and won't listen to reason. `MINUS ONE DISPOSITION`
      * -> End
  * Poke fun `MINUS ONE DISPOSITION`
  * Silence `MINUS ONE DISPOSITION`

## Willing to Negotiate
* Dismiss idea "You can do it in your own time"
  * Feels dismissed `SET STUBBORN` `SET BLOCKCHAIN CONVO OVER`
  * -> End
* We can try later
  * Feels dismissed `SET STUBBORN` `SET BLOCKCHAIN CONVO OVER`
  * -> End
* _Try prototyping_
  * This is a good idea! `SET BLOCKCHAIN CONVO OVER`
  * Admits idea was a bit overzealous!
  * -> End
