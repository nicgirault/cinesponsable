gulp = require 'gulp'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
rename = require 'gulp-rename'
replace = require 'gulp-replace'

gulp.task 'jade-index', (done) ->
  if process.env.PLATEFORM?.toLowerCase() is 'mobile'
    src = "src/indexmobile.jade"
  else
    src = 'src/index.jade'
  gulp.src([src])
    .pipe(replace '%TRACKING_MODE%', ->
      if process.env.NODE_ENV?.toLowerCase() is 'dev'
        return 'none'
      else
        return 'auto'
    )
    .pipe(jade())
    .on 'error', gutil.log
    .pipe(rename('index.html'))
    .pipe gulp.dest('www/')
    .on 'end', done
  return
