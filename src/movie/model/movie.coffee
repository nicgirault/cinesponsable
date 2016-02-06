angular.module 'Cinesponsable.theater'
.factory 'Movie', (Parse) ->
  class Movie extends Parse.Model
    @configure(
      "Movie",
      "type",
      "originalTitle",
      "title",
      "genres"
      "synopsisShort",
      "casting",
      "poster"
    )
