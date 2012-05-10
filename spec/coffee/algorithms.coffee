describe 'evaluation of different test algorithms', ->

  beforeEach ->
    resetGlobalEnvironment()

  run = (expression) ->
    evalExpression parseTokens tokenize expression

  it 'should execute a simple loop', ->
    run '(define (x a) (if (eq? a 0) 0 (x (- a 1))))'
    result = run '(x 5)'
    expect(result.toString()).toEqual '0'

  it 'should calculate the length of a list', ->
    run '(define LEN (lambda (L) (if (eq? L nil) 0 (+ (LEN (rest L)) 1))))'
    result = run '(LEN \'(1 2 3 4 5))'
    expect(result.toString()).toEqual '5'

  it 'should execute map', ->
    run '(define (map L worker) (if  (eq? L nil)
      nil (cons (worker (first L)) (map (rest L) worker))))'
    result = run '(map \'(1 2 3 4 5) (lambda (a) (+ a 1)))'
    expect(result.toString()).toEqual '\'(2 3 4 5 6)'

  it 'should execute reduce', ->
    run '(define (reduce list op) (if (eq? nil (rest list))
      (first list) (op (first list) (reduce (rest list) op))))'
    result = run '(reduce \'(1 2 3 4 5) +)'
    expect(result.toString()).toEqual '15'

  it 'should execute filter', ->
   run '(define (filter list pred) (if (eq? list nil) nil (
      if (pred (first list)) (cons (first list)
      (filter (rest list) pred)) (filter (rest list) pred))))'
   result = run '(filter \'(1 2 3 4 5) (lambda (x) (eq? x 1)))'
   expect(result.toString()).toEqual '\'(1)'

  it 'should define a scoped variable with let syntax', ->
    result =  run '(let ((a 1) (b 2) ) (+ a b))'
    expect(result.toString()).toEqual '3'

  it 'should execute quicksort', ->
    run '(define null nil)'
    run '(define mylength (lambda (L) (if (eq? L null) 0 (+ (mylength   (rest L)) 1))))'
    run '(define (append2 l1 l2) (if (eq? l1 null) l2 (cons (first l1) (append2 (rest l1) l2))))'
    run '(define (append3 a b c) (append2 a (append2 b c)))'
    run '(define (myfilter pred list) (if (eq? list null)
        null (if (pred (first list)) (cons (first list)
        (myfilter pred (rest list))) (myfilter pred (rest list)))))'
    run '(define (quicksort list) (if (<= (mylength list) 1) list
        (let ((pivot (first list))) (append3 (quicksort (myfilter (lambda (x) (< x pivot)) list))
        (myfilter  (lambda (x) (eq? x pivot)) list)
        (quicksort (myfilter  (lambda (x) (> x pivot)) list))))))'
    result = run '(quicksort \'(2 4 6 1 0 83 5 3))'
    expect(result.toString()).toEqual '\'(0 1 2 3 4 5 6 83)'

  it 'should set a variable value with set!', ->
    run '(define a 5)'
    run '(set! a 6)'
    result = run 'a'
    expect(result.toString()).toEqual '6'

  it 'should set an outer variable if a local var is not present', ->
    run '(define a 5)'
    run '(define (set-a) (if (eq? 1 1) (set! a 10) false))'
    run '(set-a)'
    result = run 'a'
    expect(result.toString()).toEqual '10'

  it 'should execute a list of statements with begin', ->
    result = run '(begin 5 4 3 2 1)'
    expect(result.toString()).toEqual '1'

  it 'should return the last element of a list with last', ->
    result = run '(last \'(3 2 1))'
    expect(result.toString()).toEqual '1'

  it 'should define an object and execute it\'s functions', ->
    run '(define (make-point x y) (define (get-x) x) (define (get-y) y) (define (set-x! newX) (set! x newX)) (define (set-y! newY)
         (set! y newY)) (define (area) (* x y)) (define (dispatch op) (if (eq? op \'get-x) get-x (if (eq? op \'get-y) get-y
         (if (eq? op \'set-x!) set-x! (if (eq? op \'set-y!) set-y! (if (eq? op \'area) area -1)))))) dispatch)'
    run '(define point (make-point 5 5))'
    result = run '((point \'get-x))'
    expect(result.toString()).toEqual '5'
    run '((point \'set-x!) 10)'
    result = run '((point \'get-x))'
    expect(result.toString()).toEqual '10'

