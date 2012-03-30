describe 'expression evalution', ->
  
  it 'should evaluate a nested expression', ->
    expression = [new Lisp.Var('+'),
                    [new Lisp.Var('+'), new Lisp.Number(1), new Lisp.Number(1)],
                    [new Lisp.Var('+'), new Lisp.Number(1), new Lisp.Number(1)]]
    evaluated = evalExpression expression
    expect(evaluated).toEqual new Lisp.Number 4

describe 'list builder', ->
  
  it 'should build a nested list', ->
    values = [1,2,3]
    list = buildList values
    expected = new Lisp.Cons(1,new Lisp.Cons(2,new Lisp.Cons(3, Lisp.Nil)))
    expect(list).toEqual expected