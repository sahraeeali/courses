;;exercise 1
(def accounts (ref [0 0 0 0 0]))

(defn balance [id]
  (nth @accounts id))

(defn credit [id amount]
  (dosync
    (alter accounts assoc id (+ (balance id) amount))))

(defn debit [id amount]
  (credit id (- amount)))

(credit 1 10)
(print @accounts)

;;exercise 2
;; time
(def t (atom 0))
;; boolean showing presence of people on the main chair
(def main-chair (atom 0))
;; a number between 0 and 3 representing the number of occupied spare chairs.
(def spare-chairs (atom 0))
;; the number of people who got haircut
(def count-p (atom 0))

;; handles time
(defn main
  [x mc sc]
  (while (< @x 10000)
  ;;10ms < rand < 30ms
  (def rand (+ 10 (rand-int 20)))
  (reset! x (+ rand @x))
  (if (= @mc 0)
    (reset! mc 1)
    (if (< @sc 3)
      (reset! sc (+ 1 @sc))))
  (Thread/sleep rand)
  ;;(println @x)
  ))

;;handles number of people in queue (mc: main chair)
(defn empty-mc
  [x mc sc p]
  (while (< @x 10000)
    (if (= @mc 1)
      (do (Thread/sleep 20) (reset! mc 0) (reset! count-p (+ 1 @p)) (println @p)))
  ))

;; delivers people from sc to mc (sc: spare chairs)
(defn sc-to-mc
  [x mc sc]
  (while (< @x 10000)
    (if (and (= @mc 0) (< @sc 0))
      (do (reset! mc 1) (reset! sc (- 1 @sc))))
    ))

(future (main t main-chair spare-chairs) 100)
(future (empty-mc t main-chair spare-chairs count-p) 100)
(future (sc-to-mc t main-chair count-p) 100)
