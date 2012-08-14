describe 'compiler', ->

  run = (expression) ->
    Compiler.compile parseTokens tokenize expression

  it 'should compile a symbol to string', ->
    expect(run('(myFunc \'a)')).toEqual 'myFunc("a")'

  it 'should compile a cons', ->
    expect(run('(cons 1 2)')).toEqual '[].concat(1, 2)'

  it 'should compile a list', ->
    expect(run('\'(1 2 3 4 5)')).toEqual '[1, 2, 3, 4, 5]'

  it 'should compile first', ->
    expect(run('(first \'(1 2 3))')).toEqual '[1, 2, 3][0]'

  it 'should compile last', ->
    expect(run('(last \'(1 2 3))')).toEqual '[1, 2, 3].slice(-1)[0]'

  it 'should compile rest', ->
    expect(run('(rest \'(1 2 3))')).toEqual '[1, 2, 3].slice(1)'

  it 'should compile an arithmetic expression with plus', ->
    expect(run('(+ 1 1 1)')).toEqual '(1 + 1 + 1)'

  it 'should compile an arithmetic expression with minus', ->
    expect(run('(- 1 1 1)')).toEqual '(1 - 1 - 1)'

  it 'should compile an arithmetic expression with multiply', ->
    expect(run('(* 1 1 1)')).toEqual '(1 * 1 * 1)'

  it 'should compile an arithmetic expression with divide', ->
    expect(run('(/ 1 1 1)')).toEqual '(1 / 1 / 1)'

  it 'should compile a nested arithmetic expression', ->
    expect(run('(+ 1 1 (* 1 1))')).toEqual '(1 + 1 + (1 * 1))'

  it 'should compile the equals operator', ->
    expect(run('(eq? 1 2)')).toEqual '__EQ(1, 2)'

  it 'should compile a logical not', ->
    expect(run('(not (eq? 1 1))')).toEqual '!(__EQ(1, 1))'

  it 'should compile a logical and', ->
    expect(run('(and true true false)')).toEqual '(true && true && false)'

  it 'should compile a logical or', ->
    expect(run('(or (eq? 1 1) (eq? 2 2) (eq? "a" "a"))'))
      .toEqual '(__EQ(1, 1) || __EQ(2, 2) || __EQ("a", "a"))'

  it 'should define a variable', ->
    expect(run('(define a 5)')).toEqual 'var a = 5;'

  it 'should compile set', ->
    expect(run('(set! a 5)')).toEqual 'a = 5;'

  it 'should define a lambda', ->
    expect(run('(define plus (lambda (a b c) (+ a b c)))'))
      .toEqual 'var plus = function(a, b, c) {\n\treturn (a + b + c);\n};'

  it 'should define a lambda with alternative syntax', ->
    expect(run('(define (plus a b c) (+ c b a) (+ a b c))'))
      .toEqual 'var plus = function(a, b, c) {\n\t(c + b + a);\n\treturn (a + b + c);\n};'

  it 'should compile multiple expressions with begin', ->
    expect(run('(begin (+ 1 2) (+ 3 4) (+ 5 6))'))
      .toEqual '(function() {\n\t(1 + 2);\n\t(3 + 4);\n\treturn (5 + 6);\n})();'

  it 'should create local variables with let', ->
    expect(run('(let ((a 5) (b 10)) (+ a b))'))
      .toEqual '(function() { var a = 5; var b = 10; return (a + b); })()'

  it 'should make a non builtin function call', ->
    expect(run('(myFunction 1 2 3)')).toEqual 'myFunction(1, 2, 3)'

  it 'should compile an if-else expression', ->
    expect(run('(if (eq? 1 1) (+ 1 1) (+ 2 2))')).toEqual '(__EQ(1, 1)) ? (1 + 1) : (2 + 2)'

  it 'should compile print', ->
    expect(run('(print 5)')).toEqual 'console.log(5);'

