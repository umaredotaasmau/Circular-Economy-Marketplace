;; Material Listing Contract

(define-map materials
  { material-id: uint }
  {
    seller: principal,
    name: (string-ascii 50),
    description: (string-utf8 500),
    quantity: uint,
    price: uint,
    quality-score: uint,
    status: (string-ascii 20)
  }
)

(define-data-var material-nonce uint u0)

(define-public (list-material
  (name (string-ascii 50))
  (description (string-utf8 500))
  (quantity uint)
  (price uint)
  (quality-score uint))
  (let
    ((new-id (+ (var-get material-nonce) u1)))
    (map-set materials
      { material-id: new-id }
      {
        seller: tx-sender,
        name: name,
        description: description,
        quantity: quantity,
        price: price,
        quality-score: quality-score,
        status: "available"
      }
    )
    (var-set material-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-material-status (material-id uint) (new-status (string-ascii 20)))
  (let
    ((material (unwrap! (map-get? materials { material-id: material-id }) (err u404))))
    (asserts! (is-eq tx-sender (get seller material)) (err u403))
    (map-set materials
      { material-id: material-id }
      (merge material { status: new-status })
    )
    (ok true)
  )
)

(define-read-only (get-material (material-id uint))
  (map-get? materials { material-id: material-id })
)

