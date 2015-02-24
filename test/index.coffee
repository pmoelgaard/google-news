assert = require("assert")
should = require("should")

describe 'GoogleNews', () ->

  GoogleNews = require('../index')

  it 'should be a ObjectFactory', () ->
    googleNews = new GoogleNews()
    should.exist(GoogleNews)

  describe '#constructor', () ->
    it 'should return an instance of GoogleNews', () ->
      googleNews = new GoogleNews()
      should.exist(googleNews)