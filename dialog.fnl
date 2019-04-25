;;; general-purpose dialog engine

(local chars {})

(var said nil)
(var who nil)
(var choices nil)
(var choice nil)
(var current-talk nil)

(local convos {})
(local events {})

(fn distance [a b]
  (let [x (- a.x (if b.w (+ b.x (* b.w 3)) b.x))
        y (- a.y (if b.h (+ b.y (* b.h 3)) b.y))]
    (math.sqrt (+ (* x x) (* y y)))))

(fn publish [...]
  (each [_ event (ipairs [...])]
    (tset events (. event :event) true)))

(fn has-happened [event-name] (= true (. events event-name)))

(fn describe [...]
  (let [prev-who who]
    (set who nil)
    (set said (table.concat [...] "\n"))
    (coroutine.yield)
    (set who prev-who)
    (set said nil)))

(fn say [...]
  (set said (table.concat [...] "\n"))
  (coroutine.yield)
  (set said nil))

(fn say-as [name ...]
  (let [prev-who who]
    (set who (and name (assert (. chars name) (.. name " not found"))))
    (say ...)
    (set who prev-who)))

(fn reply [...]
  (say-as :Nikita ...))

(fn ask [q ch]
  (set (said choices choice) (values q ch 1))
  (let [answer (coroutine.yield)]
    (set (said choices choice) nil)
    answer))

(local talk-range 16)

(fn find-convo [x y]
  (var target nil)
  (var target-dist talk-range)
  (var char nil)
  (each [name c (pairs chars)]
    (when (and (. convos name)
               (< (distance {:x x :y y} c)
                  target-dist))
      (set target name)
      (set target-dist (distance {:x x :y y} c))
      (set char c)))
  (values (. convos target) char))

(fn choose [dir]
  (when (and current-talk choice)
    (set choice (-> (+ dir choice)
                    (math.max 1)
                    (math.min (# choices))))))

(fn dialog [x y act? cancel?]
  (when act?
    (if current-talk
        (do (assert (coroutine.resume current-talk
                                      (and choices (. choices choice))))
            (when (= (coroutine.status current-talk)
                     "dead")
              (set current-talk nil)))
        (let [(convo char) (find-convo x y)]
          (when convo
            (set current-talk (coroutine.create convo))
            (set who char)
            (coroutine.resume current-talk)))))
  (when cancel?
    (set current-talk nil))
  (and current-talk {:said said :who who :choices choices}))

;; This can be useful for launch-mode where there's really only one conversation
;; going on instead of walking around among multiple characters.
(fn set-dialog [f]
  (set current-talk (coroutine.create f))
  (set who (. chars :Nikita))
  (coroutine.resume current-talk))

(var said-reveal 1)
(var last-reveal nil)
(var talk-sound 0)
(var reveal-delay 0)

(fn play-talk-sound []
  (set talk-sound (- talk-sound 1))
  (when (and (<= talk-sound 0) who)
    (when (< 1 (math.random 8))
      (let [duration (math.random 12)]
        (set talk-sound duration)
        (sfx 1 50 duration)))))

(fn draw-dialog [portrait-key]
  (when said
    (let [box-height (if (and choices (> (# choices) 3))
                         (+ 12 (* (# choices) 10))
                         42)
          box-height (if (= said "") (- box-height 10) box-height)]
      (rect 0 0 238 box-height 13)
      (rectb 1 1 236 (- box-height 2) 15))
    (when (~= last-reveal said)
      (set said-reveal 1))
    (when (and (= reveal-delay 0) (= "|" (: said :sub said-reveal said-reveal)))
      (set reveal-delay 30))
    (print (-> said
               (: :sub 1 said-reveal)
               (: :gsub "|" "")) ; pipes used as delay markers
           38 6)
    (when (<= said-reveal (# said))
      (play-talk-sound)
      (when (<= reveal-delay 1)
        (set said-reveal (+ said-reveal 1)))
      (when (< 0 reveal-delay)
        (set reveal-delay (- reveal-delay 1))))
    (when (and who (. who portrait-key))
      (print who.name 5 26)
      (spr (. who portrait-key) 8 6 0 1 0 0 2 2))
    (when choices
      (each [i ch (ipairs choices)]
        (let [choice-y (if (= said "") 0 8)]
          (when (= i choice)
            (print ">" 32 (+ choice-y (* 8 i))))
          (print ch 38 (+ choice-y (* 8 i))))))
    (set last-reveal said)))
