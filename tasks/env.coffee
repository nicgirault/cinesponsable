gulp = require 'gulp'
ngConstant = require 'gulp-ng-constant'

gulp.task 'env', ->
  ngConstant
    name: 'Cinesponsable.constants'
    constants:
      API_URL: process.env.API_URL or 'http://localhost:8000'
      PLATEFORM: process.env.PLATEFORM or 'DESKTOP' # DESKTOP || MOBILE
    stream: true
  .pipe gulp.dest './src'
