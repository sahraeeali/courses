;; clojure 1.11.1
;; OpenJDK 64-Bit Server VM (build 11.0.17+8-post-Ubuntu-1ubuntu218.04)
;; Day 1
;; exercise 1
(defn big [st n]
  (
    if (> (count st) n)
    true
    false
    ))


;; exercise 2
(defn collection-type [col]
    ( cond
      (map? col) :map
      (list? col) :list
      (vector? col) :vector
      :else :unknown_collection_type
    )
)

(collection-type {:a "a", :b "b", :c "c", :d "d"})
(collection-type list("a","b","c","d"))
