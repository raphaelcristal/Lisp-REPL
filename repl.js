(function() {
  var GLOBALS, KEYS, checkInput, evalExpression, evalTokens, newLine, parseValue, tokenize,
    _this = this;

  KEYS = {
    ENTER: 13
  };

  GLOBALS = {
    '+': function(x) {
      return x.reduce(function(a, b) {
        return a + b;
      });
    },
    '-': function(x) {
      return x.reduce(function(a, b) {
        return a - b;
      });
    },
    '*': function(x) {
      return x.reduce(function(a, b) {
        return a * b;
      });
    },
    '/': function(x) {
      return x.reduce(function(a, b) {
        return a / b;
      });
    },
    'define': function(x) {
      GLOBALS[x[0]] = x[1];
    }
  };

  window.onload = function() {
    var inputArea;
    inputArea = document.getElementById('inputArea');
    inputArea.onkeydown = checkInput;
    inputArea.onkeyup = newLine;
    inputArea.focus();
    return inputArea.setSelectionRange(2, 2);
  };

  checkInput = function(event) {
    var inputArea, lastLine, lines, parsed, result, tokens;
    if (event.keyCode === KEYS.ENTER) {
      inputArea = document.getElementById('inputArea');
      lines = inputArea.value.split('\n');
      lastLine = lines[lines.length - 1];
      lastLine = lastLine.replace('\$ ', '');
      if (lastLine === 'clear') {
        inputArea.value = '';
        return;
      }
      tokens = tokenize(lastLine);
      parsed = evalTokens(tokens);
      result = evalExpression(parsed);
      if (result != null) return inputArea.value += '\n' + result;
    }
  };

  newLine = function(event) {
    var inputArea;
    if (event.keyCode === KEYS.ENTER) {
      inputArea = document.getElementById('inputArea');
      return inputArea.value += "$ ";
    }
  };

  tokenize = function(string) {
    var token, tokens, withSpaces, _i, _len, _results;
    withSpaces = string.replace(/\(/g, ' ( ');
    withSpaces = withSpaces.replace(/\)/g, ' ) ');
    tokens = withSpaces.split(' ');
    _results = [];
    for (_i = 0, _len = tokens.length; _i < _len; _i++) {
      token = tokens[_i];
      if (token !== '') _results.push(token);
    }
    return _results;
  };

  evalTokens = function(tokens) {
    var expression, token;
    token = tokens.shift();
    if (token === '(') {
      expression = [];
      while (tokens[0] !== ')') {
        expression.push(evalTokens(tokens));
      }
      tokens.shift();
      return expression;
    } else {
      return parseValue(token);
    }
  };

  parseValue = function(value) {
    var parsed;
    parsed = Number(value);
    if (isNaN(parsed)) return value;
    return parsed;
  };

  evalExpression = function(expression) {
    var exp, func, x;
    switch (typeof expression) {
      case 'object':
        exp = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = expression.length; _i < _len; _i++) {
            x = expression[_i];
            _results.push(evalExpression(x));
          }
          return _results;
        })();
        func = exp.shift();
        return func(exp);
      case 'string':
        if (expression in GLOBALS) return GLOBALS[expression];
        return expression;
      case 'number':
        return expression;
      default:
        throw 'error';
    }
  };

}).call(this);
