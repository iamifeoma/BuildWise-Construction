;; Constants and Error Codes
(define-constant CONTRACT-ADMIN tx-sender)
(define-constant ERR-PERMISSION-DENIED (err u1))
(define-constant ERR-ITEM-EXISTS (err u2))
(define-constant ERR-ITEM-NOT-FOUND (err u404))
(define-constant ERR-INVALID-PARAMETER (err u3))
(define-constant ERR-SETUP-REQUIRED (err u4))
(define-constant ERR-INVALID-ITEM-ID (err u5))

;; Global Variables
(define-data-var system-activated bool false)

;; Data Maps
(define-map materials
    {item-id: uint}
    {
        item-name: (string-ascii 50),
        stock-level: uint,
        cost-per-unit: uint,
        certified: bool
    }
)

(define-map workforce
    {worker-id: uint}
    {
        worker-name: (string-ascii 50),
        wage-rate: uint,
        certified: bool
    }
)

(define-map machinery
    {machine-id: uint}
    {
        machine-name: (string-ascii 50),
        service-interval: (string-ascii 50),
        certified: bool
    }
)

;; Input Validation Functions
(define-private (is-valid-identifier (value uint))
    (and (> value u0) (< value u1000000))
)

(define-private (is-valid-text (value (string-ascii 50)))
    (and (not (is-eq value "")) (>= (len value) u1) (<= (len value) u50))
)

(define-private (is-valid-number (value uint))
    (and (> value u0) (< value u1000000000))
)

;; Authorization Functions
(define-private (assert-admin-only)
    (if (is-eq tx-sender CONTRACT-ADMIN)
        (ok true)
        ERR-PERMISSION-DENIED
    )
)

(define-private (assert-system-ready)
    (if (var-get system-activated)
        (ok true)
        ERR-SETUP-REQUIRED
    )
)

;; Helper Functions
(define-private (validate-machine-name (name (string-ascii 50)))
    (if (is-valid-text name)
        (ok name)
        ERR-INVALID-PARAMETER)
)

(define-private (validate-service-interval (interval (string-ascii 50)))
    (if (is-valid-text interval)
        (ok interval)
        ERR-INVALID-PARAMETER)
)

;; Public Functions
(define-public (activate-system)
    (begin
        (try! (assert-admin-only))
        (asserts! (not (var-get system-activated)) ERR-PERMISSION-DENIED)
        (var-set system-activated true)
        (ok true))
)

(define-public (register-material (item-id uint) (item-name (string-ascii 50)) (stock-level uint) (cost-per-unit uint))
    (begin
        ;; Initial input validation
        (asserts! (is-valid-identifier item-id) ERR-INVALID-ITEM-ID)
        (asserts! (is-valid-text item-name) ERR-INVALID-PARAMETER)
        (asserts! (is-valid-number stock-level) ERR-INVALID-PARAMETER)
        (asserts! (is-valid-number cost-per-unit) ERR-INVALID-PARAMETER)
        
        ;; Authorization checks
        (try! (assert-system-ready))
        (try! (assert-admin-only))
        
        ;; Business logic
        (asserts! (is-none (map-get? materials {item-id: item-id})) ERR-ITEM-EXISTS)
        (ok (map-insert materials
            {item-id: item-id}
            {
                item-name: item-name,
                stock-level: stock-level,
                cost-per-unit: cost-per-unit,
                certified: true
            }))
    )
)

(define-public (register-worker (worker-id uint) (worker-name (string-ascii 50)) (wage-rate uint))
    (begin
        ;; Initial input validation
        (asserts! (is-valid-identifier worker-id) ERR-INVALID-ITEM-ID)
        (asserts! (is-valid-text worker-name) ERR-INVALID-PARAMETER)
        (asserts! (is-valid-number wage-rate) ERR-INVALID-PARAMETER)
        
        ;; Authorization checks
        (try! (assert-system-ready))
        (try! (assert-admin-only))
        
        ;; Business logic
        (asserts! (is-none (map-get? workforce {worker-id: worker-id})) ERR-ITEM-EXISTS)
        (ok (map-insert workforce
            {worker-id: worker-id}
            {
                worker-name: worker-name,
                wage-rate: wage-rate,
                certified: true
            }))
    )
)

(define-public (register-machine (machine-id uint) (machine-name (string-ascii 50)) (service-interval (string-ascii 50)))
    (begin
        ;; Initial input validation
        (asserts! (is-valid-identifier machine-id) ERR-INVALID-ITEM-ID)
        (asserts! (is-valid-text machine-name) ERR-INVALID-PARAMETER)
        (asserts! (is-valid-text service-interval) ERR-INVALID-PARAMETER)
        
        ;; Authorization checks
        (try! (assert-system-ready))
        (try! (assert-admin-only))
        
        ;; Business logic
        (asserts! (is-none (map-get? machinery {machine-id: machine-id})) ERR-ITEM-EXISTS)
        (ok (map-insert machinery
            {machine-id: machine-id}
            {
                machine-name: machine-name,
                service-interval: service-interval,
                certified: true
            }))
    )
)

;; Add stricter validation functions
(define-private (validate-machine-text (value (string-ascii 50)))
    (if (and 
            (is-valid-text value)
            ;; Add additional validation rules as needed
            (not (is-eq value ""))
            (<= (len value) u50)
            ;; Could add more specific rules here
        )
        (ok value)
        ERR-INVALID-PARAMETER)
)

(define-private (validate-optional-machine-text (opt-value (optional (string-ascii 50))) (current-value (string-ascii 50)))
    (match opt-value
        value (validate-machine-text value)
        (ok current-value)
    )
)

(define-public (modify-machine (machine-id uint) (new-machine-name (optional (string-ascii 50))) (new-service-interval (optional (string-ascii 50))))
    (begin
        ;; Initial input validation
        (asserts! (is-valid-identifier machine-id) ERR-INVALID-ITEM-ID)
        
        ;; Authorization checks
        (try! (assert-system-ready))
        (try! (assert-admin-only))
        
        ;; Business logic
        (match (map-get? machinery {machine-id: machine-id})
            machine-data
            (let
                (
                    ;; Get current values
                    (current-name (get machine-name machine-data))
                    (current-interval (get service-interval machine-data))
                    
                    ;; Validate new values with explicit error handling
                    (validated-name (try! (validate-optional-machine-text new-machine-name current-name)))
                    (validated-interval (try! (validate-optional-machine-text new-service-interval current-interval)))
                )
                
                ;; Additional post-validation checks
                (asserts! (is-valid-text validated-name) ERR-INVALID-PARAMETER)
                (asserts! (is-valid-text validated-interval) ERR-INVALID-PARAMETER)
                
                ;; Update with fully validated data
                (ok (map-set machinery
                    {machine-id: machine-id}
                    {
                        machine-name: validated-name,
                        service-interval: validated-interval,
                        certified: true
                    }))
            )
            ERR-ITEM-NOT-FOUND
        )
    )
)

(define-public (remove-machine (machine-id uint))
    (begin
        ;; Initial input validation
        (asserts! (is-valid-identifier machine-id) ERR-INVALID-ITEM-ID)
        
        ;; Authorization checks
        (try! (assert-system-ready))
        (try! (assert-admin-only))
        
        ;; Business logic
        (asserts! (is-some (map-get? machinery {machine-id: machine-id})) ERR-ITEM-NOT-FOUND)
        (ok (map-delete machinery {machine-id: machine-id}))
    )
)

(define-public (inspect-machine (machine-id uint))
    (begin
        ;; Initial input validation
        (asserts! (is-valid-identifier machine-id) ERR-INVALID-ITEM-ID)
        
        ;; Authorization check
        (try! (assert-system-ready))
        
        ;; Business logic
        (match (map-get? machinery {machine-id: machine-id})
            machine-data (ok machine-data)
            ERR-ITEM-NOT-FOUND)
    )
)