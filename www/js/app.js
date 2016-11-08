'use strict';
angular.module('Cinesponsable', ['ng', 'ngResource', 'ngAnimate', 'ngMaterial', 'ui.router', 'app.templates', 'leaflet-directive', 'Cinesponsable.common', 'Cinesponsable.theater', 'Cinesponsable.showtime', 'Cinesponsable.movie', 'Cinesponsable.map', 'Cinesponsable.search', 'Cinesponsable.constants']).config(function($mdGestureProvider) {
  return $mdGestureProvider.skipClickHijack();
}).config(function($mdIconProvider) {
  return $mdIconProvider.defaultIconSet('icons/mdi.light.svg');
}).config(function($locationProvider, $urlRouterProvider) {
  $locationProvider.hashPrefix('!');
  return $urlRouterProvider.otherwise('/map');
}).run(function() {
  return _.groupByMulti = function(obj, values, context) {
    var byFirst, prop, rest;
    if (!values.length) {
      return obj;
    }
    byFirst = _.groupBy(obj, values[0], context);
    rest = values.slice(1);
    for (prop in byFirst) {
      byFirst[prop] = _.groupByMulti(byFirst[prop], rest, context);
    }
    return byFirst;
  };
});

angular.module("Cinesponsable.constants", [])

.constant("API_URL", "//api.indecine.fr")

;
angular.module('Cinesponsable.common', []);

angular.module('Cinesponsable.map', []);

angular.module('Cinesponsable.movie', ['Cinesponsable.constants']);

angular.module('Cinesponsable.search', []);

angular.module('Cinesponsable.showtime', []);

angular.module('Cinesponsable.theater', []);

angular.module('Cinesponsable.common').config(function($stateProvider) {
  return $stateProvider.state('base', {
    templateUrl: 'common/states/base/view.html',
    controller: 'BaseCtrl',
    abstract: true
  }).state('base.tabs', {
    templateUrl: 'common/states/tabs/view.html',
    controller: 'TabsCtrl',
    abstract: true
  });
});

angular.module('Cinesponsable.common').filter('htmlToPlaintext', function() {
  return function(text) {
    if (text) {
      return String(text).replace(/<[^>]+>/gm, '');
    } else {
      return '';
    }
  };
});

angular.module('Cinesponsable.common').service('Position', function(position) {
  return {
    get: function() {
      return position.get().then(function(position) {
        return {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
      })["catch"](function(err) {
        return {
          lat: 48.860779,
          lng: 2.340175
        };
      });
    }
  };
});

angular.module('Cinesponsable.map').config(function($stateProvider) {
  return $stateProvider.state('base.tabs.map', {
    url: '/map',
    templateUrl: 'map/states/main/view.html',
    controller: 'MapCtrl',
    data: {
      tab: 'map'
    },
    resolve: {
      currentPosition: function(position) {
        return position.get().then(function(position) {
          return {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
          };
        })["catch"](function(err) {
          return {
            latitude: 48.860779,
            longitude: 2.340175
          };
        });
      }
    }
  });
});

angular.module('Cinesponsable.map').service('position', function($q) {
  return {
    get: function() {
      var deferred;
      deferred = $q.defer();
      navigator.geolocation.getCurrentPosition(function(position) {
        return deferred.resolve(position);
      }, function(err) {
        console.warn(err);
        return deferred.reject(err);
      }, {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      });
      return deferred.promise;
    }
  };
});

angular.module('Cinesponsable.movie').config(function($stateProvider) {
  return $stateProvider.state('base.movieList', {
    url: '/movie',
    templateUrl: 'movie/states/list/view.html',
    controller: 'MovielistCtrl',
    data: {
      tab: 'movies'
    }
  }).state('base.movieDetails', {
    url: '/movie/:movieId',
    templateUrl: 'movie/states/details/view.html',
    controller: 'MovieDetailsCtrl'
  });
});

angular.module('Cinesponsable.theater').service('Movie', function($resource, API_URL) {
  return $resource("" + API_URL + "/api/Movies/:movieId:action", {
    movieId: '@id'
  }, {
    onTheBill: {
      method: 'GET',
      params: {
        action: 'on-the-bill'
      },
      isArray: true
    }
  });
});

angular.module('Cinesponsable.showtime').run(function() {
  return moment.locale('fr', {
    months: 'janvier_février_mars_avril_mai_juin_juillet_août_septembre_octobre_novembre_décembre'.split('_'),
    monthsShort: 'janv._févr._mars_avr._mai_juin_juil._août_sept._oct._nov._déc.'.split('_'),
    weekdays: 'dimanche_lundi_mardi_mercredi_jeudi_vendredi_samedi'.split('_'),
    weekdaysShort: 'dim._lun._mar._mer._jeu._ven._sam.'.split('_'),
    weekdaysMin: 'Di_Lu_Ma_Me_Je_Ve_Sa'.split('_'),
    longDateFormat: {
      LT: 'HH:mm',
      LTS: 'HH:mm:ss',
      L: 'DD/MM/YYYY',
      LL: 'D MMMM YYYY',
      LLL: 'D MMMM YYYY LT',
      LLLL: 'dddd D MMMM YYYY LT'
    },
    calendar: {
      sameDay: '[Aujourd\'hui à] LT',
      nextDay: '[Demain à] LT',
      nextWeek: 'dddd [à] LT',
      lastDay: '[Hier à] LT',
      lastWeek: 'dddd [dernier à] LT',
      sameElse: 'L'
    },
    relativeTime: {
      future: 'dans %s',
      past: 'il y a %s',
      s: 'quelques secondes',
      m: 'une minute',
      mm: '%d minutes',
      h: 'une heure',
      hh: '%d heures',
      d: 'un jour',
      dd: '%d jours',
      M: 'un mois',
      MM: '%d mois',
      y: 'une année',
      yy: '%d années'
    },
    ordinalParse: /\d{1,2}(er|ème)/,
    ordinal: function(number) {
      return number + (number === 1 ? 'er' : 'ème');
    },
    meridiemParse: /PD|MD/,
    isPM: function(input) {
      return input.charAt(0) === 'M';
    },
    meridiem: function(hours, minutes, isLower) {
      if (hours < 12) {
        return 'PD';
      } else {
        return 'MD';
      }
    },
    week: {
      dow: 1,
      doy: 4
    }
  });
});

angular.module('Cinesponsable.showtime').config(function($stateProvider) {
  return $stateProvider.state('base.showtimeByTheater', {
    url: '/theater/:theaterId/showtime',
    templateUrl: 'showtime/states/by-theater/view.html',
    controller: 'ShowtimeCtrl'
  }).state('base.showtimeByMovie', {
    url: '/movie/:movieId/showtime',
    templateUrl: 'showtime/states/by-movie/view.html',
    controller: 'ShowtimeByMovieCtrl'
  });
});

angular.module('Cinesponsable.theater').service('Showtime', function($resource, API_URL) {
  return $resource("" + API_URL + "/api/Showtimes/:showtimeId:action", {
    showtimeId: '@id'
  });
});

angular.module('Cinesponsable.theater').config(function($stateProvider) {
  return $stateProvider.state('base.tabs.theaters', {
    url: '/theaters',
    templateUrl: 'theater/states/list/view.html',
    controller: 'TheaterListCtrl',
    data: {
      tab: 'theaters'
    }
  });
});

angular.module('Cinesponsable.theater').service('Theater', function($resource, API_URL) {
  return $resource("" + API_URL + "/api/Theaters/:theaterId:action/:actionPerTheater", {
    theaterId: '@id'
  });
});

angular.module('Cinesponsable.common').controller('BaseCtrl', function($scope, $state) {
  $scope.state = $state;
});

angular.module('Cinesponsable.common').controller('TabsCtrl', function($scope, $state) {
  $scope.state = $state;
});

angular.module('Cinesponsable.map').directive('mapPopup', function() {
  return {
    restrict: 'E',
    templateUrl: 'map/directives/map-popup/view.html',
    scope: {
      title: '@',
      subtitle: '@',
      id: '@'
    }
  };
});

angular.module('Cinesponsable.map').controller('MapCtrl', function($scope, Theater, currentPosition) {
  angular.extend($scope, {
    userPosition: {
      lat: currentPosition.latitude,
      lng: currentPosition.longitude,
      zoom: 13
    },
    data: {
      markers: {}
    }
  });
  return Theater.query().$promise.then(function(theaters) {
    var markers, theater, _i, _len;
    markers = {};
    for (_i = 0, _len = theaters.length; _i < _len; _i++) {
      theater = theaters[_i];
      markers[theater.code] = {
        lat: theater.geopoint.lat,
        lng: theater.geopoint.lng,
        compileMessage: true,
        message: "<map-popup title='" + theater.name + "' subtitle='" + theater.address + " " + theater.postalCode + " " + theater.city + "' id='" + theater.id + "'>"
      };
    }
    $scope.theaters = theaters;
    $scope.data.markers = {};
    angular.extend($scope.data, {
      markers: markers
    });
    $scope.ready = true;
  });
});

angular.module('Cinesponsable.movie').controller('MovieDetailsCtrl', function($scope, $stateParams, Movie) {
  $scope.ready = false;
  return Movie.get({
    movieId: $stateParams.movieId
  }).$promise.then(function(movie) {
    $scope.movie = movie;
    return $scope.ready = true;
  });
});

angular.module('Cinesponsable.movie').controller('MovielistCtrl', function($scope, Movie, position) {
  $scope.ready = false;
  return Movie.onTheBill().$promise.then(function(movies) {
    $scope.movies = movies;
    return $scope.ready = true;
  });
});

angular.module('Cinesponsable.search').controller('searchBarCtrl', function($scope, $state, Theater) {
  var repos;
  $scope.searchTextChange = function(text) {};
  $scope.itemChange = function(item) {
    var _ref;
    if ((item != null ? (_ref = item.constructor) != null ? _ref.name : void 0 : void 0) === 'Theater') {
      $state.go('base.showtime', {
        theaterId: item.code
      });
    }
  };
  repos = [
    {
      'name': 'Angular 1',
      'url': 'https://github.com/angular/angular.js',
      'watchers': '3,623',
      'forks': '16,175'
    }, {
      'name': 'Angular 2',
      'url': 'https://github.com/angular/angular',
      'watchers': '469',
      'forks': '760'
    }, {
      'name': 'Angular Material',
      'url': 'https://github.com/angular/material',
      'watchers': '727',
      'forks': '1,241'
    }, {
      'name': 'Bower Material',
      'url': 'https://github.com/angular/bower-material',
      'watchers': '42',
      'forks': '84'
    }, {
      'name': 'Material Start',
      'url': 'https://github.com/angular/material-start',
      'watchers': '81',
      'forks': '303'
    }
  ];
  repos.map(function(repo) {
    repo.value = repo.name.toLowerCase();
    return repo;
  });
  $scope.simulateQuery = false;
  return $scope.isDisabled = false;
});

angular.module('Cinesponsable.search').directive('searchBar', function() {
  return {
    restrict: 'E',
    templateUrl: 'search/directives/search-bar/view.html',
    controller: 'searchBarCtrl'
  };
});

angular.module('Cinesponsable.showtime').controller('ShowtimeByMovieCtrl', function($scope, $q, $stateParams, $window, Showtime, Movie, Position) {
  $scope.ready = false;
  Position.get().then(function(position) {
    return $q.all([
      Showtime.query({
        filter: {
          include: 'theater',
          where: {
            movieId: $stateParams.movieId,
            and: [
              {
                datetime: {
                  gt: new Date()
                }
              }, {
                datetime: {
                  lt: moment().add(7, 'days').toDate()
                }
              }
            ],
            order: 'datetime ASC',
            position: "" + position.lat + ";" + position.lng
          }
        }
      }).$promise, Movie.get({
        movieId: $stateParams.movieId
      }).$promise
    ]);
  }).then(function(_arg) {
    var groupByDay, movie, showtime, showtimes, _i, _len;
    showtimes = _arg[0], movie = _arg[1];
    for (_i = 0, _len = showtimes.length; _i < _len; _i++) {
      showtime = showtimes[_i];
      showtime.day = moment(showtime.datetime).format('dddd D MMMM');
    }
    $scope.theaters = _.keyBy(showtimes, 'theaterId');
    $scope.movie = movie;
    groupByDay = function(showtime) {
      return moment(showtime.datetime).format('DD-MM-YY');
    };
    $scope.groupedShowtimes = _.groupByMulti(showtimes, ['theaterId', 'language', groupByDay]);
    return $scope.ready = true;
  });
  return $scope.back = function() {
    return $window.history.back();
  };
});

angular.module('Cinesponsable.showtime').controller('ShowtimeCtrl', function($scope, $stateParams, Showtime, Movie) {
  $scope.ready = false;
  return Showtime.query({
    filter: {
      where: {
        and: [
          {
            datetime: {
              gt: new Date()
            }
          }, {
            datetime: {
              lt: moment().add(7, 'days').toDate()
            }
          }
        ],
        theaterId: $stateParams.theaterId
      },
      order: 'datetime ASC'
    }
  }).$promise.then(function(showtimes) {
    var groupByDay, groupedShowtimes, movieIds, showtime, _i, _len;
    movieIds = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = showtimes.length; _i < _len; _i++) {
        showtime = showtimes[_i];
        _results.push(showtime.movieId);
      }
      return _results;
    })();
    for (_i = 0, _len = showtimes.length; _i < _len; _i++) {
      showtime = showtimes[_i];
      showtime.day = moment(showtime.datetime).format('dddd D MMMM');
    }
    groupByDay = function(showtime) {
      return moment(showtime.datetime).format('DD-MM-YY');
    };
    groupedShowtimes = _.groupByMulti(showtimes, ['movieId', 'language', groupByDay]);
    $scope.groupedShowtimes = groupedShowtimes;
    return Movie.query({
      filter: {
        where: {
          id: {
            inq: _.uniq(movieIds)
          }
        }
      }
    }).$promise;
  }).then(function(movies) {
    $scope.movies = movies;
    return $scope.ready = true;
  });
});

angular.module('Cinesponsable.showtime').controller('DetailsCtrl', function($scope, showtime, $mdDialog) {
  var genre, genres, seance, time, times, _i, _len, _ref;
  $scope.showtime = showtime;
  $scope.releaseDate = moment(showtime.onShow.movie.release.releaseDate).format("dddd D MMMM YYYY");
  _ref = $scope.showtime.scr;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    seance = _ref[_i];
    seance.date = moment(seance.d).format("dddd D MMMM YYYY");
    times = (function() {
      var _j, _len1, _ref1, _results;
      _ref1 = seance.t;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        time = _ref1[_j];
        _results.push(time.$);
      }
      return _results;
    })();
    seance.time = times.join(', ');
  }
  genres = (function() {
    var _j, _len1, _ref1, _results;
    _ref1 = showtime.onShow.movie.genre;
    _results = [];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      genre = _ref1[_j];
      _results.push(genre.$);
    }
    return _results;
  })();
  $scope.genres = genres.join(', ');
  $scope.cancel = function() {
    return $mdDialog.cancel();
  };
  return $scope.versionLabel = {
    "true": "original",
    "false": "doublage"
  };
});

angular.module('Cinesponsable.theater').controller('TheaterListCtrl', function($scope, $state, Theater, Position) {
  $scope.ready = false;
  Position.get().then(function(position) {
    return Theater.query({
      filter: {
        where: {
          geopoint: {
            near: [position.lat, position.lng]
          }
        },
        limit: 20
      }
    }).$promise;
  }).then(function(theaters) {
    $scope.theaters = theaters;
    return $scope.ready = true;
  });
  return $scope.showtime = function(theater) {
    return $state.go('base.showtimeByTheater', {
      theaterId: theater.id
    });
  };
});
