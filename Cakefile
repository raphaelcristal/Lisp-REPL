{print} = require 'util'
{spawn} = require 'child_process'

interpreter = if process.platform is 'win32' then 'coffee.cmd' else 'coffee'

spawnInterpreter = (options, callback) ->
  coffee = spawn interpreter, options
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  coffee.stdout.on 'data', (data) ->
    print data.toString()
  coffee.on 'exit', (code) ->
    callback?() if code is 0
  

build = (options) ->
  coffee = spawnInterpreter ['-c', '-o', 'src/js', 'src/coffee']

test =   ->
  spawnInterpreter ['-b', '-c', '-o', 'src/barejs', 'src/coffee']
  spawnInterpreter ['-b', '-c', '-o', 'spec/barejs', 'spec/coffee']

testWatch =   ->
  spawnInterpreter ['-w', '-b', '-c', '-o', 'src/barejs', 'src/coffee']
  spawnInterpreter ['-w', '-b', '-c', '-o', 'spec/barejs', 'spec/coffee']

task 'build', 'compile and join sources', build
task 'test', 'compile src so it can be tested with SpecRunner', test
task 'testWatch', 'compile tests on save', testWatch
