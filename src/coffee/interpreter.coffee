BUILTINS =
  '+': new Lisp.Procedure('+', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value + b.value)
  '-': new Lisp.Procedure('-', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value - b.value)
  '*': new Lisp.Procedure('*', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value * b.value)
  '/': new Lisp.Procedure('/', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value / b.value)
  'cons': (x) -> new Lisp.Cons x[0], x[1]

class Environment
  costructor: (@parent=Null) ->
    
  find: (value) ->
    @ if value of @ else @parent.find value
  
  updateValues: (values) ->
    for key,value of values
      @[key] = value
    

globalEnvironment = new Environment
globalEnvironment.updateValues BUILTINS
  
evalExpression = (expression, env=globalEnvironment) ->
    if expression.type is 'JList'
      evaluated = (evalExpression x for x in expression)
      procedure = evaluated.shift()
      procedure(evaluated)
    else if expression.type is 'Symbol' and expression.value of env
      env[expression.value]
    else
      expression
    
window.evalExpression = evalExpression
window.globalEnvironment = globalEnvironment