describe 'Tokenizer', ->
  
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
  
   
  
