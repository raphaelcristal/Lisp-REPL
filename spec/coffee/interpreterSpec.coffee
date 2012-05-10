describe 'expression evalution', ->

  beforeEach ->
    resetGlobalEnvironment()

  it 'should evaluate a nested expression', ->
    expression = [new Lisp.Symbol('+'),
                    [new Lisp.Symbol('+'), new Lisp.Number(1), new Lisp.Number(1)],
                    [new Lisp.Symbol('+'), new Lisp.Number(1), new Lisp.Number(1)]]
    evaluated = evalExpression expression
    expect(evaluated).toEqual new Lisp.Number 4

  it 'should define a global variable', ->
    expression = [new Lisp.Symbol('define'), new Lisp.Symbol('b'), new Lisp.Number(1)]
    evalExpression expression
    expect(globalEnvironment['b']).toEqual new Lisp.Number 1

  it 'should define a global lambda and evaluated it', ->
    expression = [new Lisp.Symbol('define'), new Lisp.Symbol('myFunc')]
    lambdaExpr = [new Lisp.Symbol('lambda'),
                  [new Lisp.Symbol('a')],
                  [new Lisp.Symbol('+'), new Lisp.Symbol('a'), new Lisp.Symbol('a')]]
    expression.push lambdaExpr
    evalExpression expression
    args = [new Lisp.Number(1)]
    expect(globalEnvironment['myFunc'](args)).toEqual new Lisp.Number 2

  it 'should define a globale lambda with alternative syntax and evaluate it', ->
    expression = [new Lisp.Symbol('define'),
                   [new Lisp.Symbol('plus'), new Lisp.Symbol('a')],
                   [new Lisp.Symbol('+'), new Lisp.Symbol('a'), new Lisp.Symbol('a')]]
    evalExpression expression
    args = [new Lisp.Number(1)]
    expect(globalEnvironment['plus'](args)).toEqual new Lisp.Number 2

  it 'should throw an exception for an undefined identifier', ->
    expression = [new Lisp.Symbol('x')]
    expect( -> evalExpression(expression)).toThrow new Error 'reference to undefined identifier: x'



describe 'builtins', ->


  it 'should reset the global environment for this suite', ->
    resetGlobalEnvironment()

  it 'should add a list of numbers', ->
    numbers = (new Lisp.Number x for x in [1..10])
    result = globalEnvironment['+'](numbers)
    expect(result).toEqual new Lisp.Number 55

  it 'should subtract a list of numbers', ->
    numbers = (new Lisp.Number x for x in [10,2,1])
    result = globalEnvironment['-'](numbers)
    expect(result).toEqual new Lisp.Number 7

  it 'should multiply a list of numbers', ->
    numbers = (new Lisp.Number x for x in [1..10])
    result = globalEnvironment['*'](numbers)
    expect(result).toEqual new Lisp.Number 3628800

  it 'should divide a list of numbers', ->
    numbers = (new Lisp.Number x for x in [100,5,2])
    result = globalEnvironment['/'](numbers)
    expect(result).toEqual new Lisp.Number 10

  it 'should compare two values with greater than operator', ->
    expressionTrue = [new Lisp.Symbol('>'), new Lisp.Number(10), new Lisp.Number(9)]
    expressionFalse = [new Lisp.Symbol('>'), new Lisp.Number(1), new Lisp.Number(2)]
    expect(evalExpression(expressionTrue)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should compare two values with greater equals operator', ->
    exprTrue1 = [new Lisp.Symbol('>='), new Lisp.Number(10), new Lisp.Number(9)]
    exprTrue2 = [new Lisp.Symbol('>='), new Lisp.Number(10), new Lisp.Number(10)]
    expressionFalse = [new Lisp.Symbol('>='), new Lisp.Number(1), new Lisp.Number(2)]
    expect(evalExpression(exprTrue1)).toBe Lisp.True
    expect(evalExpression(exprTrue2)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should compare two values with lesser than operator', ->
    expressionTrue = [new Lisp.Symbol('<'), new Lisp.Number(2), new Lisp.Number(10)]
    expressionFalse = [new Lisp.Symbol('<'), new Lisp.Number(2), new Lisp.Number(1)]
    expect(evalExpression(expressionTrue)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should compare two values with lesser equals operator', ->
    exprTrue1 = [new Lisp.Symbol('<='), new Lisp.Number(2), new Lisp.Number(10)]
    exprTrue2 = [new Lisp.Symbol('<='), new Lisp.Number(10), new Lisp.Number(10)]
    expressionFalse = [new Lisp.Symbol('<='), new Lisp.Number(2), new Lisp.Number(1)]
    expect(evalExpression(exprTrue1)).toBe Lisp.True
    expect(evalExpression(exprTrue2)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should compare two numbers for equality', ->
    expressionTrue = [new Lisp.Symbol('eq?'), new Lisp.Number(1), new Lisp.Number(1)]
    expressionFalse = [new Lisp.Symbol('eq?'), new Lisp.Number(2), new Lisp.Number(1)]
    expect(evalExpression(expressionTrue)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should compare two cons for equality', ->
    cons = new Lisp.Cons 1,2
    expressionTrue = [new Lisp.Symbol('eq?'), cons, cons]
    expressionFalse = [new Lisp.Symbol('eq?'), new Lisp.Cons(1,2), new Lisp.Cons(1,2)]
    expect(evalExpression(expressionTrue)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should compare booleans for equality', ->
    exprTrue1 = [new Lisp.Symbol('eq?'), Lisp.True, Lisp.True]
    exprTrue2 = [new Lisp.Symbol('eq?'), Lisp.False, Lisp.False]
    expressionFalse = [new Lisp.Symbol('eq?'), Lisp.True, Lisp.False]
    expect(evalExpression(exprTrue1)).toBe Lisp.True
    expect(evalExpression(exprTrue2)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should evaluate if expressions', ->
    expressionTrue = [new Lisp.Symbol('if'),
                        [new Lisp.Symbol('eq?'), new Lisp.Number(2), new Lisp.Number(2)],
                        Lisp.True, Lisp.False]
    expressionFalse = [new Lisp.Symbol('if'),
                        [new Lisp.Symbol('eq?'), new Lisp.Number(1), new Lisp.Number(2)],
                        Lisp.True, Lisp.False]
    expect(evalExpression(expressionTrue)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False

  it 'should return the first element of a cons', ->
    expression = [new Lisp.Symbol('first'),
                   [new Lisp.Symbol('cons'), new Lisp.Number(1), new Lisp.Number(2)]]
    expect(evalExpression(expression)).toEqual new Lisp.Number 1

  it 'should return the rest of a cons', ->
    expression = [new Lisp.Symbol('rest'),
                   [new Lisp.Symbol('cons'), new Lisp.Number(1), new Lisp.Number(2)]]
    expect(evalExpression(expression)).toEqual new Lisp.Number 2

  it 'should evaluate several boolean true values with and', ->
    expression = [new Lisp.Symbol('and'),
                  [new Lisp.Symbol('eq?'), new Lisp.Number(1), new Lisp.Number(1)],
                  [new Lisp.Symbol('<'), new Lisp.Number(1), new Lisp.Number(2)],
                  [new Lisp.Symbol('>'), new Lisp.Number(2), new Lisp.Number(1)]]
    expect(evalExpression(expression)).toEqual Lisp.True

  it 'should evaluate false for and if one item is false', ->
    expression = [new Lisp.Symbol('and'),
                  [new Lisp.Symbol('eq?'), new Lisp.Number(1), new Lisp.Number(1)],
                  [new Lisp.Symbol('<'), new Lisp.Number(2), new Lisp.Number(1)]]
    expect(evalExpression(expression)).toEqual Lisp.False

  it 'should evaluate several booleans values with or', ->
    expression = [new Lisp.Symbol('or'),
                  [new Lisp.Symbol('eq?'), new Lisp.Number(1), new Lisp.Number(1)],
                  [new Lisp.Symbol('<'), new Lisp.Number(2), new Lisp.Number(1)],
                  [new Lisp.Symbol('>'), new Lisp.Number(2), new Lisp.Number(1)]]
    expect(evalExpression(expression)).toEqual Lisp.True

  it 'should evaluate a single boolean expression with not', ->
    expression = [new Lisp.Symbol('not'),
                  [new Lisp.Symbol('eq?'), new Lisp.Number(1), new Lisp.Number(1)]]
    expect(evalExpression(expression)).toEqual Lisp.False
