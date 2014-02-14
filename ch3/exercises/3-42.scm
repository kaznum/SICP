;; It is safe. On both cases, the procedures are managed on the same serializer.
;; In the original case, each calling the dispatch function sets new feed for procedure, so it could make the list of serialized functions' references in the serializer which might result in the performance disadvantage. (It depends on the implementation of the serializer.)
