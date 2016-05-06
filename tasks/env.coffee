gulp = require 'gulp'
ngConstant = require 'gulp-ng-constant'

gulp.task 'env', ->
  ngConstant
    name: 'Cinesponsable.constants'
    constants:
      API_URL: process.env.CINELOCAL_API_URL or 'http://localhost:8000'
    stream: true
  .pipe gulp.dest './src'
