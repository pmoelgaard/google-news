should = require("should")
assert = require("assert")

describe 'GoogleNews', () ->

  GoogleNews = require('../index');

  describe '#constructor', () ->
    it 'should return a GoogleNews Object', () ->
      should.exist(GoogleNews)