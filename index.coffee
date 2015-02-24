util = require 'util'
request = require 'request'
extend = require 'deep-extend'
URLHash = require('nx-url-hash')
Loki = require 'lokijs'
FeedParser = require('feedparser')
EventEmitter = require('events').EventEmitter;

class GoogleNews

  @DATA: 'google.news.data'
  @ERROR: 'google.news.error'
  @ATOM: 'atom'
  @RSS: 'rss'

  constructor: (options = {}) ->
    this.options = extend(
      {},
      {
        cacheFileName: 'google-news.json'
        host: 'news.google.com'
        service: 'news/feeds'
        pollInterval: 1000 * 60 * 15
        protocol: 'https'
        params:
          cf: 'all'
          hl: 'en'
          lang: 'en'
          output: GoogleNews.ATOM
      },
      options
    )

    this.cacheProvider = new Loki(options.cacheFileName)
    this.urlHash = new URLHash()

  stream: (track, callback) ->
    class GoogleNewsStream

      util.inherits(GoogleNewsStream, EventEmitter);

      constructor: (context, track) ->
        this.context = context
        this.track = track
        this.options = context.options
        this.cache = context.cacheProvider.addCollection("#{this.options.host}/#{this.options.host}")
        ### Every 1 min ###
        this.connectTrigger = setInterval(this.connect, this.options.pollInterval)
        ### Trigger at start ###
        this.connect()


      connect: () =>
        feedParser = new FeedParser()

        feedParser.on 'readable', () =>
          while( item = feedParser.read() )
            item.guid = this.generateGuid(item.guid)
            existingItems = this.cache.find({guid: item.guid})
            if existingItems.length is 0
              this.cache.insert(item)
              this.onData(item)

        feedParser.on 'error', (error) =>
          this.onError(error)

        args =
          qs: extend {}, this.options.params, {q: this.track}
          uri: "#{this.options.protocol}://#{this.options.host}/#{this.options.service}"

        feed = request(args)
        feed.on 'response', () =>
          feed.pipe(feedParser);


      disconnect: () =>
        clearInterval(this.checkTrigger)


      onData: (data) =>
        this.emit(GoogleNews.DATA, data)

      onError: (error) =>
        this.emit GoogleNews.ERROR, error

      generateGuid: (uri) =>
        guid = this.context.urlHash.hash(uri)
        return guid

    stream = new GoogleNewsStream(this, track)
    callback(stream)


    return


module.exports = GoogleNews