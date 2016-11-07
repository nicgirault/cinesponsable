gulp = require 'gulp'
gulp.task 'please-wait-css', (done) ->
  gulp.src [
    'bower_components/please-wait/build/please-wait.css'
  ]
  .pipe gulp.dest('www/css')
  .on 'end', done
  return
gulp.task 'please-wait-js', (done) ->
  gulp.src [
    'bower_components/please-wait/build/please-wait.min.js'
  ]
  .pipe gulp.dest('www/js')
  .on 'end', done
  return
