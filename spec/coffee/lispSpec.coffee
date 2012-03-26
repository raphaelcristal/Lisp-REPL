describe 'Datatypes', ->
  
  it 'boolean', ->
    expect(Lisp.True.value).toEqual true
    expect(Lisp.False.value).toEqual false
    expect(Lisp.True.toString()).toEqual '#t'
    expect(Lisp.False.toString()).toEqual '#f'
 
  it 'cons', ->
    cons = new Lisp.Cons 1,2
    expect(cons.first).toEqual 1
    expect(cons.rest).toEqual 2
    expect(cons.toString()).toEqual '\'(1 . 2)'
   
    
  it 'nil', ->
    nil = new Lisp.Nil
    expect(nil.value).toBeNull
    expect(nil.toString()).toEqual 'Nil'  
    
  it 'number', ->
    number1 = new Lisp.Number 5
    number2 = new Lisp.Number 1.3434
    expect(number1.value).toEqual 5
    expect(number2.value).toEqual 1.3434
    expect(number1.toString()).toEqual '5'
    expect(number2.toString()).toEqual '1.3434'
  
  it 'procedure', ->
    procedure = new Lisp.Procedure "+", (a,b) -> a+b
    expect(procedure.toString()).toEqual "#<procedure:+>"
    expect(procedure 1,2).toEqual 3
      
  it 'symbol', ->
    symbol1 = new Lisp.Symbol 'abcd'
    symbol2 = new Lisp.Symbol '5'
    expect(symbol1.value).toEqual 'abcd'
    expect(symbol2.value).toEqual '5'
    expect(symbol1.toString()).toEqual '\'abcd'
    expect(symbol2.toString()).toEqual '\'5'

describe 'builtins', ->
  
  it 'should add a list of numbers', ->
    numbers = (new Lisp.Number x for x in [1..10])
    result = GLOBALS['+'](numbers)
    expect(result).toEqual new Lisp.Number 55
    
  it 'should subtract a list of numbers', ->
    numbers = (new Lisp.Number x for x in [10,2,1])
    result = GLOBALS['-'](numbers)
    expect(result).toEqual new Lisp.Number 7
    
  it 'should multiply a list of numbers', ->
    numbers = (new Lisp.Number x for x in [1..10])
    result = GLOBALS['*'](numbers)
    expect(result).toEqual new Lisp.Number 3628800
    
  it 'should divide a list of numbers', ->
    numbers = (new Lisp.Number x for x in [100,5,2])
    result = GLOBALS['/'](numbers)
    expect(result).toEqual new Lisp.Number 10
    
    
