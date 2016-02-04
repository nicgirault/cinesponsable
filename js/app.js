'use strict';
angular.module('Cinesponsable', ['ng', 'ngResource', 'ngAnimate', 'ngMaterial', 'ui.router', 'app.templates', 'Parse', 'leaflet-directive', 'Cinesponsable.common', 'Cinesponsable.theater', 'Cinesponsable.alloCine', 'Cinesponsable.showtime', 'Cinesponsable.map']).config(function(ParseProvider) {
  return ParseProvider.initialize("2Y3JhneedL6TfTswvBgPfJbZ0qxQRJHj8jg0GqEU", "w1ek8EuSk7dD8bEBDSN5J8XTyXlGuOgx8mv7q7MD");
}).constant('ALLOCINE_API_URL', 'http://api.allocine.fr/rest/v3').constant('ALLOCINE_PARTNER_TOKEN', 'yW5kcm9pZC12M3M').config(function($mdGestureProvider) {
  return $mdGestureProvider.skipClickHijack();
}).config(function($locationProvider, $urlRouterProvider) {
  $locationProvider.hashPrefix('!');
  return $urlRouterProvider.otherwise('/map');
});

angular.module('Cinesponsable.alloCine', []);

angular.module('Cinesponsable.common', []);

angular.module('Cinesponsable.map', []);

angular.module('Cinesponsable.showtime', []);

angular.module('Cinesponsable.theater', []);

angular.module('Cinesponsable.theater').config(function($stateProvider) {
  return $stateProvider.state('base.admin', {
    url: '/admin',
    templateUrl: 'allo-cine/states/admin/view.html',
    controller: 'AlloCineAdminCtrl'
  });
});

angular.module('Cinesponsable.alloCine').service('AlloCine', function($resource, ALLOCINE_API_URL, ALLOCINE_PARTNER_TOKEN, Movie, $q) {
  var AlloCineMovieList, AlloCineShowTime, AlloCineTheater;
  AlloCineShowTime = $resource(ALLOCINE_API_URL + '/showtimelist?partner=:partner&format=json&theaters=:alloCineId');
  AlloCineTheater = $resource(ALLOCINE_API_URL + '/theaterlist?partner=:partner&format=json&theaters=:alloCineId');
  AlloCineMovieList = $resource(ALLOCINE_API_URL + '/movielist?partner=:partner&count=:count&order=theatercount&format=json&filter=nowshowing');
  return {
    getTheaterInfo: function(code) {
      return AlloCineTheater.get({
        partner: ALLOCINE_PARTNER_TOKEN,
        alloCineId: code
      }).$promise.then(function(data) {
        var result, _ref, _ref1;
        result = null;
        if (_.isArray((_ref = data.feed) != null ? _ref.theater : void 0)) {
          result = _.find((_ref1 = data.feed) != null ? _ref1.theater : void 0, {
            code: code
          });
          if (result != null) {
            result.alloCineId = code;
          }
        }
        return result;
      });
    },
    getShowtimes: function(alloCineId) {
      return AlloCineShowTime.get({
        partner: ALLOCINE_PARTNER_TOKEN,
        alloCineId: alloCineId
      }).$promise.then(function(data) {
        var _ref, _ref1;
        return data != null ? (_ref = data.feed) != null ? (_ref1 = _ref.theaterShowtimes[0]) != null ? _ref1.movieShowtimes : void 0 : void 0 : void 0;
      });
    },
    fetchMovies: function() {
      return AlloCineMovieList.get({
        partner: ALLOCINE_PARTNER_TOKEN,
        count: 1
      }).$promise.then(function(data) {
        var totalResults, _ref;
        totalResults = data != null ? (_ref = data.feed) != null ? _ref.totalResults : void 0 : void 0;
        if (totalResults == null) {
          return;
        }
        return AlloCineMovieList.get({
          partner: ALLOCINE_PARTNER_TOKEN,
          count: totalResults
        }).$promise.then(function(data) {
          var movies, _ref1;
          movies = data != null ? (_ref1 = data.feed) != null ? _ref1.movie : void 0 : void 0;
          return async.eachSeries(movies, function(m, callback) {
            var genre, movie, _ref2;
            movie = new Movie();
            movie.type = m.movieType.$;
            movie.originalTitle = m.originalTitle;
            movie.title = m.title;
            movie.genres = (function() {
              var _i, _len, _ref2, _results;
              _ref2 = m.genre;
              _results = [];
              for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
                genre = _ref2[_i];
                _results.push(genre.$);
              }
              return _results;
            })();
            movie.synopsisShort = m.synopsisShort;
            movie.casting = m.castingShort;
            movie.poster = (_ref2 = m.poster) != null ? _ref2.href : void 0;
            return movie.save().then(function() {
              console.log('saving movie: ' + m.originalTitle, movie);
              return callback();
            });
          });
        });
      });
    }
  };
});

angular.module('Cinesponsable.alloCine').service('theaterIds', function() {
  return ['P7912', 'P0212', 'P1347', 'P0155', 'P2014', 'P8740', 'W0132', 'P0987', 'P0448', 'claudine goiffon??', 'P0974', 'W0030', 'P0675', 'W2622', 'W0750', 'P2219', 'P2164', 'W0278', 'P0262', 'P1004', 'P2131', 'P4335', 'W2680', 'P0541', 'P2143', 'MJC', 'P7908', 'P2163', 'W1229', 'W2626', 'P4334', 'P8567', 'P0286', 'P2130', 'P0212', 'P2600', 'P7882'];
});

angular.module('Cinesponsable.common').config(function($stateProvider) {
  return $stateProvider.state('base', {
    templateUrl: 'common/states/base/view.html',
    controller: 'BaseCtrl',
    abstract: true
  });
});

angular.module('Cinesponsable.map').config(function($stateProvider) {
  return $stateProvider.state('base.map', {
    url: '/map',
    templateUrl: 'map/states/main/view.html',
    controller: 'MapCtrl',
    data: {
      tab: 'map'
    },
    resolve: {
      theaters: function(Theater) {
        return Theater.query();
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

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Cinesponsable.theater').factory('Movie', function(Parse) {
  var Movie;
  return Movie = (function(_super) {
    __extends(Movie, _super);

    function Movie() {
      return Movie.__super__.constructor.apply(this, arguments);
    }

    Movie.configure("Movie", "type", "originalTitle", "title", "genres", "synopsisShort", "casting", "poster");

    return Movie;

  })(Parse.Model);
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
  return $stateProvider.state('base.showtime', {
    url: '/theater/:theaterId/showtime',
    templateUrl: 'showtime/states/theater-showtime/view.html',
    controller: 'ShowtimeCtrl',
    resolve: {
      showtimes: function(Theater, AlloCine, $stateParams) {
        if ($stateParams.theaterId == null) {
          return null;
        }
        if ($stateParams.theaterId != null) {
          return AlloCine.getShowtimes($stateParams.theaterId);
        }
      },
      theater: function(Theater, AlloCine, $stateParams) {
        var theater;
        if ($stateParams.theaterId == null) {
          return null;
        }
        theater = {
          alloCineId: $stateParams.theaterId
        };
        return AlloCine.getTheaterInfo(theater);
      }
    },
    params: {
      theater: null
    }
  });
});

angular.module('Cinesponsable.theater').config(function($stateProvider) {
  return $stateProvider.state('base.theaters', {
    url: '/theaters',
    templateUrl: 'theater/states/list/view.html',
    controller: 'TheaterListCtrl',
    data: {
      tab: 'theaters'
    },
    resolve: {
      theaters: function(Theater) {
        return Theater.query();
      }
    }
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Cinesponsable.theater').factory('Theater', function(Parse) {
  var Theater;
  return Theater = (function(_super) {
    __extends(Theater, _super);

    function Theater() {
      return Theater.__super__.constructor.apply(this, arguments);
    }

    Theater.configure("Theater", "code", "name", "address", "locality", "state", "country", "geopoint", "pictures", "hasPRMAccess", "screenNumber");

    Theater.getClosestTheaters = function(geopoint, limit) {
      if (limit == null) {
        limit = 10;
      }
      return this.query({
        where: {
          geopoint: {
            $nearSphere: {
              __type: "GeoPoint",
              latitude: geopoint.latitude,
              longitude: geopoint.longitude
            }
          }
        },
        limit: limit
      });
    };

    return Theater;

  })(Parse.Model);
});

angular.module('Cinesponsable.alloCine').controller('AlloCineAdminCtrl', function($scope, theaterIds, AlloCine, Theater) {
  $scope.fetchTheaters = function() {
    var code, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = theaterIds.length; _i < _len; _i++) {
      code = theaterIds[_i];
      console.log("handling " + code);
      _results.push(AlloCine.getTheaterInfo(code).then(function(info) {
        var theater, _ref, _ref1, _ref2;
        if (!info) {
          return;
        }
        theater = new Theater({
          code: info.code,
          name: info.name,
          address: info.address,
          locality: {
            name: info.city,
            postalCode: info.postalCode
          },
          state: info.area,
          country: "France",
          geopoint: new Parse.GeoPoint({
            latitude: (_ref = info.geoloc) != null ? _ref.lat : void 0,
            longitude: (_ref1 = info.geoloc) != null ? _ref1.long : void 0
          }),
          pictures: [],
          hasPRMAccess: info.hasPRMAccess === 1 ? true : false,
          screenNumber: info.screenCount
        });
        if (((_ref2 = info.picture) != null ? _ref2.href : void 0) != null) {
          theater.pictures.push(info.picture.href);
        }
        return theater.save();
      }));
    }
    return _results;
  };
  return $scope.fetchMovies = AlloCine.fetchMovies;
});

angular.module('Cinesponsable.common').controller('BaseCtrl', function($scope, $state) {
  $scope.state = $state;
  return console.log($state.current);
});

angular.module('Cinesponsable.map').directive('mapPopup', function() {
  return {
    restrict: 'E',
    templateUrl: 'map/directives/map-popup/view.html',
    scope: {
      title: '@',
      subtitle: '@',
      code: '@'
    }
  };
});

angular.module('Cinesponsable.map').controller('MapCtrl', function($scope, theaters, Theater, currentPosition, leafletMarkerEvents) {
  var markers, theater, _i, _len;
  angular.extend($scope, {
    userPosition: {
      lat: currentPosition.latitude,
      lng: currentPosition.longitude,
      zoom: 8
    },
    data: {
      markers: {}
    }
  });
  markers = {};
  for (_i = 0, _len = theaters.length; _i < _len; _i++) {
    theater = theaters[_i];
    markers[theater.code] = {
      lat: theater.geopoint.latitude,
      lng: theater.geopoint.longitude,
      compileMessage: true,
      message: "<map-popup title='" + theater.name + "' subtitle='" + theater.address + " " + theater.locality.postalCode + " " + theater.locality.name + "' code='" + theater.code + "'>"
    };
  }
  $scope.addMarkers = function() {
    $scope.data.markers = {};
    angular.extend($scope.data, {
      markers: markers
    });
  };
  return $scope.addMarkers();
});

angular.module('Cinesponsable.showtime').controller('ShowtimeCtrl', function($scope, theater, showtimes, $mdMedia, $mdDialog) {
  $scope.showtimes = showtimes;
  $scope.theater = theater;
  return $scope.showDetails = function(showtime, event) {
    var useFullScreen;
    useFullScreen = $mdMedia('sm') || $mdMedia('xs');
    return $mdDialog.show({
      controller: 'DetailsCtrl',
      templateUrl: 'showtime/states/theater-showtime/details.html',
      parent: angular.element(document.body),
      targetEvent: event,
      clickOutsideToClose: true,
      fullscreen: useFullScreen,
      resolve: {
        showtime: function() {
          return showtime;
        }
      }
    });
  };
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

angular.module('Cinesponsable.theater').controller('TheaterListCtrl', function($scope, $state, theaters) {
  $scope.theaters = theaters;
  return $scope.showtime = function(theater) {
    return $state.go('base.showtime', {
      theaterId: theater.code
    });
  };
});
