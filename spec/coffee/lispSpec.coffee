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
    nil = Lisp.Nil
    expect(nil.value).toBeNull
    expect(nil.toString()).toEqual '\'()'

  it 'number', ->
    number1 = new Lisp.Number 5
    number2 = new Lisp.Number 1.3434
    expect(number1.value).toEqual 5
    expect(number2.value).toEqual 1.3434
    expect(number1.toString()).toEqual '5'
    expect(number2.toString()).toEqual '1.3434'

  it 'procedure', ->
    procedure = new Lisp.Procedure "+", 'Number', (args) -> args[0]+args[1]
    expect(procedure.toString()).toEqual "#<procedure:+>"
    expect(procedure [new Lisp.Number(1), new Lisp.Number(2)]).toEqual 3

  it 'symbol', ->
    symbol1 = new Lisp.Symbol 'abcd'
    expect(symbol1.value).toEqual 'abcd'
    expect(symbol1.toString()).toEqual '\'abcd'

  it 'symbol with equal values should have the same identity', ->
    expect(new Lisp.Symbol('a')).toBe new Lisp.Symbol('a')

  it 'String', ->
    string = new Lisp.String "abc"
    expect(string.value).toEqual "abc"
    expect(string.toString()).toEqual '"abc"'
