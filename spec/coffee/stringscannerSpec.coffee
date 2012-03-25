describe 'tokenizer', ->
  
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
    
    
describe 'value parser', ->
  it 'should parse boolean true', ->
    parsed = parseValue 'true'
    expect(parsed).toBe Lisp.True
    
  it 'should parse boolean false', ->
    parsed = parseValue 'false'
    expect(parsed).toBe Lisp.False
    
  it 'should parse an integer', ->
    parsed = parseValue '1'
    expect(parsed).toEqual Lisp.Number 1
    
  it 'should parse a float', ->
    parsed = parseValue 1.1
    expect(parsed).toEqual Lisp.Number 1.1
    
  it 'should parse symbol', ->
    parsed = parseValue "'abc"
    expect(parsed).toEqual Lisp.Symbol 'abc'
  
   
  
