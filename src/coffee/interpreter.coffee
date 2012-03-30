evalExpression = (expression, env=GLOBALS) ->
    if expression.type is 'JList'
      evaluated = (evalExpression x for x in expression)
      procedure = evaluated.shift()
      procedure(evaluated)
    else if expression.type is 'Variable' and expression.value of GLOBALS
      GLOBALS[expression.value]
    else
      expression

buildList = (values) ->
  if values.length is 0
    return Lisp.Nil
  else
    return new Lisp.Cons values.shift(), buildList(values)
    
window.evalExpression = evalExpression