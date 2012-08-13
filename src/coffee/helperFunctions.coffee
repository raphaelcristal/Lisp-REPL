arrayEquals = (a, b) ->
  if a.length isnt b.length
    return false
  else
    for _,index in a
      if a[index] isnt b[index]
        return false
  true
window.__EQ = (a, b) ->
  if a instanceof Array and b instanceof Array
    arrayEquals a, b
  else
    a is b

