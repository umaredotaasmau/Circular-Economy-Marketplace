;; Marketplace Contract

(define-map transactions
  { tx-id: uint }
  {
    buyer: principal,
    seller: principal,
    item-type: (string-ascii 20),
    item-id: uint,
    amount: uint,
    status: (string-ascii 20)
  }
)

(define-data-var tx-nonce uint u0)

(define-public (create-transaction
  (seller principal)
  (item-type (string-ascii 20))
  (item-id uint)
  (amount uint))
  (let
    ((new-id (+ (var-get tx-nonce) u1)))
    (try! (stx-transfer? amount tx-sender seller))
    (map-set transactions
      { tx-id: new-id }
      {
        buyer: tx-sender,
        seller: seller,
        item-type: item-type,
        item-id: item-id,
        amount: amount,
        status: "completed"
      }
    )
    (var-set tx-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-transaction (tx-id uint))
  (map-get? transactions { tx-id: tx-id })
)

