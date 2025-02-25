;; Entanglement Pair Contract

(define-map entangled-pairs
  { pair-id: uint }
  {
    particle1: principal,
    particle2: principal,
    state: (string-ascii 20)
  }
)

(define-data-var next-pair-id uint u0)

(define-public (create-entangled-pair (particle1 principal) (particle2 principal))
  (let
    ((new-id (+ (var-get next-pair-id) u1)))
    (var-set next-pair-id new-id)
    (ok (map-set entangled-pairs
      { pair-id: new-id }
      {
        particle1: particle1,
        particle2: particle2,
        state: "superposition"
      }
    ))
  )
)

(define-public (measure-particle (pair-id uint) (particle principal))
  (let
    ((pair (unwrap! (map-get? entangled-pairs { pair-id: pair-id }) (err u404))))
    (asserts! (or (is-eq particle (get particle1 pair)) (is-eq particle (get particle2 pair))) (err u403))
    (ok (map-set entangled-pairs
      { pair-id: pair-id }
      (merge pair { state: "measured" })
    ))
  )
)

(define-read-only (get-entangled-pair (pair-id uint))
  (map-get? entangled-pairs { pair-id: pair-id })
)

