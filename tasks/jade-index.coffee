gulp = require 'gulp'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
rename = require 'gulp-rename'

gulp.task 'jade-index', (done) ->
  if process.env.PLATEFORM?
    src = "src/index#{process.env.PLATEFORM}.jade"
  else
    src = 'src/index.jade'
  gulp.src([src])
    .pipe(jade())
    .on 'error', gutil.log
    .pipe(rename('index.html'))
    .pipe gulp.dest('www/')
    .on 'end', done
  return
