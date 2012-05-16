describe 'tokenizer', ->

  it 'should remove a single line comment with linebreaks', ->
    input = tokenize '(if (eq? 1 1)\n true\n ;else\n false)'
    expected = tokenize '(if (eq? 1 1) true false)'
    expect(input).toEqual expected

  it 'should add whitespaces around closing brackets', ->
    tokenized = tokenize '(+ 1 1 (+ 1 1))'
    expect(tokenized).toEqual ['(', '+', '1', '1', '(', '+', '1', '1', ')', ')']

  it 'should add whitespaces around opening brackets', ->
    tokenized = tokenize '(+ 1 1(+ 1 1) )'
    expect(tokenized).toEqual ['(', '+', '1', '1', '(', '+', '1', '1', ')', ')']

  it 'should trim tokens and remove unnecessary white space', ->
    tokenized = tokenize '(+     1 1   ( +   1  1)   )'
    expect(tokenized).toEqual ['(', '+', '1', '1', '(', '+', '1', '1', ')', ')']

  it 'should recognize a quoted input', ->
    tokenized = tokenize '\'(a b c)'
    expect(tokenized).toEqual ['\'(', 'a', 'b', 'c', ')']

  it 'should recognize a quoted input with extra whitespaces', ->
    tokenized = tokenize '\'   (a b c)'
    expect(tokenized).toEqual ['\'(', 'a', 'b', 'c', ')']

  it 'should recognize a list', ->
    tokenized = tokenize '\'(1 2)'
    expect(tokenized).toEqual ['\'(', '1', '2', ')']


describe 'value parser', ->

  it 'should parse boolean true', ->
    parsed = parseValue 'true'
    expect(parsed).toBe Lisp.True

  it 'should parse boolean false', ->
    parsed = parseValue 'false'
    expect(parsed).toBe Lisp.False

  it 'should parse an integer', ->
    parsed = parseValue '1'
    expect(parsed).toEqual new Lisp.Number 1

  it 'should parse a float', ->
    parsed = parseValue '1.1'
    expect(parsed).toEqual new Lisp.Number 1.1

  it 'should parse a quoted value', ->
    parsed = parseValue "'abc"
    expect(parsed).toEqual new Lisp.Quoted new Lisp.Symbol 'abc'

  it 'should parse a variable as a Symbol', ->
    parsed = parseValue 'abc'
    expect(parsed).toEqual new Lisp.Symbol 'abc'

describe 'token parser', ->

  it 'should recognize a nested expression', ->
    tokens = ['(', '+', '1', '(', '+', '1', '1', ')', ')']
    parsed = parseTokens tokens
    expected = [new Lisp.Symbol('+'), new Lisp.Number(1),
                [new Lisp.Symbol('+'), new Lisp.Number(1), new Lisp.Number(1)]]
    expect(parsed).toEqual expected

  it 'should recognize a list', ->
    tokens = ['\'(', '1', 'a', ')']
    parsed = parseTokens tokens
    expected = new Lisp.Quoted new Lisp.Cons(new Lisp.Number(1), new Lisp.Cons(
                 new Lisp.Symbol('a'), Lisp.Nil))
    expect(parsed).toEqual expected

describe 'list builder', ->

  it 'should build a nested list', ->
    values = [1,2,3]
    list = buildList values
    expected = new Lisp.Cons(1,new Lisp.Cons(2,new Lisp.Cons(3, Lisp.Nil)))
    expect(list).toEqual expected
