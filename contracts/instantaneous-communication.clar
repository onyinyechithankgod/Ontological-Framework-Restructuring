;; Instantaneous Communication Contract

(define-map messages
  { message-id: uint }
  {
    sender: principal,
    receiver: principal,
    content: (string-ascii 256),
    timestamp: uint
  }
)

(define-data-var next-message-id uint u0)

(define-public (send-message (receiver principal) (content (string-ascii 256)))
  (let
    ((new-id (+ (var-get next-message-id) u1)))
    (var-set next-message-id new-id)
    (ok (map-set messages
      { message-id: new-id }
      {
        sender: tx-sender,
        receiver: receiver,
        content: content,
        timestamp: block-height
      }
    ))
  )
)

(define-read-only (get-message (message-id uint))
  (map-get? messages { message-id: message-id })
)

(define-read-only (get-messages-for-receiver (receiver principal))
  (filter (lambda (entry)
    (is-eq (get receiver (get value entry)) receiver))
    (map-to-list messages))
)

