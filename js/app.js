'use strict';
angular.module('Cinesponsable', ['ng', 'ngResource', 'ngAnimate', 'ngMaterial', 'ui.router', 'app.templates', 'Parse', 'uiGmapgoogle-maps', 'Cinesponsable.common', 'Cinesponsable.theater', 'Cinesponsable.alloCine', 'Cinesponsable.showtime', 'Cinesponsable.map']).config(function(ParseProvider) {
  return ParseProvider.initialize("2Y3JhneedL6TfTswvBgPfJbZ0qxQRJHj8jg0GqEU", "w1ek8EuSk7dD8bEBDSN5J8XTyXlGuOgx8mv7q7MD");
}).config(function($mdIconProvider) {
  return $mdIconProvider.defaultIconSet('icons/mdi.light.svg');
}).constant('ALLOCINE_API_URL', 'http://api.allocine.fr/rest/v3').constant('ALLOCINE_PARTNER_TOKEN', 'yW5kcm9pZC12M3M').config(function($locationProvider, $urlRouterProvider) {
  $locationProvider.hashPrefix('!');
  return $urlRouterProvider.otherwise('/map');
}).config(function(uiGmapGoogleMapApiProvider) {
  return uiGmapGoogleMapApiProvider.configure({
    v: '3.20',
    libraries: ''
  });
});

angular.module('Cinesponsable.alloCine', []);

angular.module('Cinesponsable.common', []);

angular.module('Cinesponsable.map', []);

angular.module('Cinesponsable.showtime', []);

angular.module('Cinesponsable.theater', []);

angular.module('Cinesponsable.alloCine').service('AlloCine', function($resource, ALLOCINE_API_URL, ALLOCINE_PARTNER_TOKEN) {
  var AlloCineTheater;
  AlloCineTheater = $resource(ALLOCINE_API_URL + '/showtimelist?partner=:partner&format=json&theaters=:alloCineId');
  return {
    getTheaterInfo: function(theater) {
      return AlloCineTheater.get({
        partner: ALLOCINE_PARTNER_TOKEN,
        alloCineId: theater.alloCineId
      }).$promise.then(function(data) {
        var place, _ref, _ref1, _ref2, _ref3;
        if (data.feed) {
          place = (_ref = data.feed.theaterShowtimes[0]) != null ? (_ref1 = _ref.place) != null ? _ref1.theater : void 0 : void 0;
          theater.name = place != null ? place.name : void 0;
          theater.address = place != null ? place.address : void 0;
          theater.postalCode = place != null ? place.postalCode : void 0;
          theater.city = place != null ? place.city : void 0;
          theater.picture = place != null ? (_ref2 = place.picture) != null ? _ref2.href : void 0 : void 0;
          theater.allocineLink = place != null ? (_ref3 = place.link[0]) != null ? _ref3.href : void 0 : void 0;
          theater.geoloc = place != null ? place.geoloc : void 0;
          theater.area = place != null ? place.area : void 0;
        }
        return theater;
      });
    },
    getShowtimes: function(alloCineId) {
      return AlloCineTheater.get({
        partner: ALLOCINE_PARTNER_TOKEN,
        alloCineId: alloCineId
      }).$promise.then(function(data) {
        var _ref, _ref1;
        return data != null ? (_ref = data.feed) != null ? (_ref1 = _ref.theaterShowtimes[0]) != null ? _ref1.movieShowtimes : void 0 : void 0 : void 0;
      });
    }
  };
});

angular.module('Cinesponsable.common').config(function($stateProvider) {
  return $stateProvider.state('base', {
    templateUrl: 'common/states/base/view.html',
    abstract: true
  });
});

angular.module('Cinesponsable.map').config(function($stateProvider) {
  return $stateProvider.state('map', {
    url: '/map',
    templateUrl: 'map/states/main/view.html',
    controller: 'MapCtrl',
    resolve: {
      theaters: function(Theater, AlloCine) {
        return Theater.query().then(function(theaters) {
          var theater, _i, _len;
          for (_i = 0, _len = theaters.length; _i < _len; _i++) {
            theater = theaters[_i];
            AlloCine.getTheaterInfo(theater);
          }
          return theaters;
        });
      }
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
    resolve: {
      theaters: function(Theater, AlloCine) {
        return Theater.query().then(function(theaters) {
          var theater, _i, _len;
          for (_i = 0, _len = theaters.length; _i < _len; _i++) {
            theater = theaters[_i];
            AlloCine.getTheaterInfo(theater);
          }
          return theaters;
        });
      }
    }
  });
});

var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

angular.module('Cinesponsable.theater').factory('Theater', function(Parse) {
  var Cinema;
  return Cinema = (function(_super) {
    __extends(Cinema, _super);

    function Cinema() {
      return Cinema.__super__.constructor.apply(this, arguments);
    }

    Cinema.configure("Cinema", "alloCineId");

    return Cinema;

  })(Parse.Model);
});

angular.module('Cinesponsable.map').controller('MapCtrl', function($scope, theaters, uiGmapGoogleMapApi) {
  $scope.theaters = theaters;
  return uiGmapGoogleMapApi.then(function(maps) {
    return $scope.map = {
      center: {
        latitude: 45,
        longitude: -73
      },
      zoom: 8
    };
  });
});

angular.module('Cinesponsable.showtime').controller('ShowtimeCtrl', function($scope, theater, showtimes) {
  $scope.showtimes = showtimes;
  $scope.theater = theater;
  return $scope.versionLabel = {
    "true": "original",
    "false": "doublage"
  };
});

angular.module('Cinesponsable.theater').controller('TheaterListCtrl', function($scope, $state, theaters) {
  $scope.theaters = theaters;
  return $scope.showtime = function(theater) {
    return $state.go('base.showtime', {
      theaterId: theater.alloCineId
    });
  };
});
