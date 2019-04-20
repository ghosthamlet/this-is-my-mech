;;;;;;;;;;;;;;;;;;;;;;;;;;;;; dialog

(local chars {})

(local coros {})

(var said nil)
(var who nil)
(var choices nil)
(var choice nil)
(var current-talk nil)

(var replying false)

(local convos {})

(fn distance [a b]
  (let [x (- a.x (if b.w (+ b.x (* b.w 3)) b.x)) y (- a.y b.y)]
    (math.sqrt (+ (* x x) (* y y)))))

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

(fn reply [...]
  (set said (table.concat [...] "\n"))
  (set replying true)
  (coroutine.yield)
  (set replying false)
  (set said nil))

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
        (do (coroutine.resume current-talk
                              (and choices (. choices choice)))
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

;; for tests
{:dialog dialog :convos convos :chars chars :say say :ask ask :choose choose}
