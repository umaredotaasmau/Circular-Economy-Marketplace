;; Upcycled Product Contract

(define-non-fungible-token upcycled-product uint)

(define-map products
  { product-id: uint }
  {
    creator: principal,
    name: (string-ascii 50),
    description: (string-utf8 500),
    price: uint,
    materials-used: (list 10 uint),
    status: (string-ascii 20)
  }
)

(define-data-var product-nonce uint u0)

(define-public (create-product
  (name (string-ascii 50))
  (description (string-utf8 500))
  (price uint)
  (materials-used (list 10 uint)))
  (let
    ((new-id (+ (var-get product-nonce) u1)))
    (try! (nft-mint? upcycled-product new-id tx-sender))
    (map-set products
      { product-id: new-id }
      {
        creator: tx-sender,
        name: name,
        description: description,
        price: price,
        materials-used: materials-used,
        status: "available"
      }
    )
    (var-set product-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-product-status (product-id uint) (new-status (string-ascii 20)))
  (let
    ((product (unwrap! (map-get? products { product-id: product-id }) (err u404))))
    (asserts! (is-eq tx-sender (get creator product)) (err u403))
    (map-set products
      { product-id: product-id }
      (merge product { status: new-status })
    )
    (ok true)
  )
)

(define-read-only (get-product (product-id uint))
  (map-get? products { product-id: product-id })
)

