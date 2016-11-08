gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'

gulp.task 'vendor', (done) ->
  gulp.src [
    'bower_components/angular/angular.min.js'
    'bower_components/angular-resource/angular-resource.min.js'
    'bower_components/angular-animate/angular-animate.min.js'
    'bower_components/angular-aria/angular-aria.min.js'
    'bower_components/angular-material/angular-material.min.js'
    'bower_components/angular-ui-router/release/angular-ui-router.min.js'
    'bower_components/lodash/dist/lodash.min.js'
    'bower_components/leaflet/dist/leaflet.js'
    'bower_components/angular-leaflet-directive/dist/angular-leaflet-directive.min.js'
    'bower_components/moment/min/moment.min.js'
  ]
  .pipe(concat('vendor.js'))
  .on 'error', gutil.log
  .pipe gulp.dest('www/js')
  .on 'end', done
  return
