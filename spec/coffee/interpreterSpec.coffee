describe 'expression evalution', ->
  
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
   
    

describe 'builtins', ->
  
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
    exprTrue1 = new Lisp.Symbol('<='), new Lisp.Number(2), new Lisp.Number(10)]
    exprTrue2 = new Lisp.Symbol('<='), new Lisp.Number(10), new Lisp.Number(10)]
    expressionFalse = [new Lisp.Symbol('<='), new Lisp.Number(2), new Lisp.Number(1)]
    expect(evalExpression(exprTrue1)).toBe Lisp.True
    expect(evalExpression(exprTrue2)).toBe Lisp.True
    expect(evalExpression(expressionFalse)).toBe Lisp.False
