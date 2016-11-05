angular.module 'Cinesponsable.common'
.filter 'htmlToPlaintext', ->
  (text) ->
    if text then String(text).replace(/<[^>]+>/gm, '') else ''
