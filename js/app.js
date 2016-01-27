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
    v: '3.21',
    libraries: ''
  });
});

angular.module('Cinesponsable.alloCine', []);

angular.module('Cinesponsable.common', []);

angular.module('Cinesponsable.map', []);

angular.module('Cinesponsable.showtime', []);

angular.module('Cinesponsable.theater', []);

angular.module('Cinesponsable.alloCine').service('AlloCine', function($resource, ALLOCINE_API_URL, ALLOCINE_PARTNER_TOKEN) {
  var AlloCineShowTime, AlloCineTheater;
  AlloCineShowTime = $resource(ALLOCINE_API_URL + '/showtimelist?partner=:partner&format=json&theaters=:alloCineId');
  AlloCineTheater = $resource(ALLOCINE_API_URL + '/theaterlist?partner=:partner&format=json&theaters=:alloCineId');
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
      theaters: function(Theater, AlloCine, $q) {
        return Theater.query();
      }
    }
  });
});

angular.module('Cinesponsable.showtime').config(function($stateProvider) {
  return $stateProvider.state('base.showtime', {
    url: '/theater/:theaterId/showtime',
    templateUrl: 'showtime/states/theater-showtime/view.html',
    controller: 'ShowtimeCtrl',
    data: {
      tab: 'theaters'
    },
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

    Theater.configure("Theater", "code", "name", "address", "locality", "state", "country", "geo", "pictures", "hasPRMAccess", "screenNumber");

    return Theater;

  })(Parse.Model);
});

angular.module('Cinesponsable.common').controller('BaseCtrl', function($scope, $state) {
  $scope.state = $state;
  return console.log($state.current);
});

angular.module('Cinesponsable.map').controller('MapCtrl', function($scope, theaters, uiGmapGoogleMapApi) {
  $scope.theaters = theaters;
  uiGmapGoogleMapApi.then(function(maps) {
    return $scope.map = {
      center: {
        latitude: 48.858181,
        longitude: 2.335000
      },
      zoom: 13
    };
  });
  return $scope.events = {
    dragend: function(maps, eventName, args) {
      var newCenter;
      return newCenter = {
        latitude: maps.center.A,
        longitude: maps.center.F
      };
    }
  };
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