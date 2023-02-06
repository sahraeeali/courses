;; Day 2 interface (defprotocol) & classes (defrecord)
;; exp 1
(defmacro unless [c then else]
  `(if (not ~c)
     ~then
     ~else))

(unless true "False" "True")
(unless false "False" "True")

;; exp 2
(defprotocol Compass
  (direction [c])
  (left [c])
  (right [c]))

(def directions [:north :east :south :west])

(defn turn [base amount]
  (rem (+ base amount) (count directions)))


(defrecord SimpleCompass [bearing]
  Compass
  (direction [_] (directions bearing))
  (left [_] (SimpleCompass. (turn bearing 3)))
  (right [_] (SimpleCompass. (turn bearing 1)))
  (toString [this] (str "[" (direction this) "]")))

(def c (SimpleCompass. 0))
