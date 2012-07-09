#taken from http://stackoverflow.com/questions/1891444/how-can-i-get-cursor-position-in-a-textarea
( ($) ->
  $.fn.getCursorPosition = ->
    el = $(@).get 0
    pos = 0
    if 'selectionStart' of el
      pos = el.selectionStart
    else if 'selection' in document
      el.focus()
      sel = document.selection.createRange()
      selLength = document.selection.createRange().text.length
      sel.moveStart 'character', -el.value.length
      pos = sel.text.length - selLength
    pos
)(jQuery)

#taken from http://stackoverflow.com/questions/499126/jquery-set-cursor-position-in-text-area
( ($) ->
  $.fn.setCursorPosition = (start, end) ->
    @.each ->
      if @.setSelectionRange
        @.focus()
        @.setSelectionRange start, end
      else if @createTextRange
        range = @.createTextRange
        range.collapse true
        range.moveEnd 'character', end
        range.moveStart 'character', start
        range.select()
)(jQuery)
