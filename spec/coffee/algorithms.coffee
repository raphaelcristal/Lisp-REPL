describe 'evaluation of different test algorithms', ->

  beforeEach ->
    resetGlobalEnvironment()

  it 'should execute a simple loop', ->
    procedure = '(define (x a) (if (eq? a 0) 0 (x (- a 1))))'
    evalExpression parseTokens tokenize procedure
    expression = '(x 5)'
    result = evalExpression parseTokens tokenize expression
    expect(result.toString()).toEqual '0'

  it 'should calculate the length of a list', ->
    procedure = '(define LEN (lambda (L) (if (eq? L nil) 0 (+ (LEN (rest L)) 1))))'
    evalExpression parseTokens tokenize procedure
    expression = '(LEN \'(1 2 3 4 5))'
    result = evalExpression parseTokens tokenize expression
    expect(result.toString()).toEqual '5'

  it 'should execute map', ->
    procedure = '(define (map L worker) (if  (eq? L nil)
      nil (cons (worker (first L)) (map (rest L) worker))))'
    evalExpression parseTokens tokenize procedure
    expression = '(map \'(1 2 3 4 5) (lambda (a) (+ a 1)))'
    result = evalExpression parseTokens tokenize expression
    expect(result.toString()).toEqual '\'(2 . \'(3 . \'(4 . \'(5 . \'(6 . ())))))'

  it 'should execute reduce', ->
    procedure = '(define (reduce list op) (if (eq? nil (rest list)) (first list) (op (first list) (reduce (rest list) op))))'
    evalExpression parseTokens tokenize procedure
    expression = '(reduce \'(1 2 3 4 5) +)'
    result = evalExpression parseTokens tokenize expression
    expect(result.toString()).toEqual '15'

  it 'should define a scoped variable with let syntax', ->
    expression =  '(let ((a 1) (b 2) ) (+ a b))'
    result = evalExpression parseTokens tokenize expression
    console.log result
