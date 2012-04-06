describe 'evaluation of different test algorithms', ->

  beforeEach ->
    resetGlobalEnvironment()

  it 'should define a scoped variable with let syntax', ->
    expression =  '(let ((a 1) (b 2) ) (+ a b))'
    result = eval parseTokens tokenize expression
    console.log result
