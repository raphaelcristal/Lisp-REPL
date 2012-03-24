#fs = require 'fs'

#{print} = require 'util'
{spawn} = require 'child_process'

interpreter = if process.platform is 'win32' then 'coffee.cmd' else 'coffee'
console.log interpreter

build = ->
  coffee = spawn interpreter, ['-c', '-o', 'src/js', 'src/coffee']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0
  console.log 'test'

task 'build', 'compile source and tests', build 