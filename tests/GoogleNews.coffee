should = require("should")
assert = require("assert")

describe 'GoogleNews', () ->

  GoogleNews = require('../index.js');

  describe '#constructor', () ->
    it 'should return a GoogleNews Object', () ->
      should.exist(GoogleNews)