path = require 'path'

indexPath = path.join __dirname, 'index.js'

GoogleNews = require indexPath

googleNews = new GoogleNews(
  pollInterval: 5000
)

track = 'Volvo'

googleNews.stream track, (stream) ->
  stream.on GoogleNews.DATA, (data) ->
    console.log 'Data Event received... ' + data.title

  stream.on GoogleNews.ERROR, (error) ->
    console.log 'Error Event received... ' + error

  return
