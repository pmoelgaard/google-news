var assert, should;

should = require("should");
assert = require("assert");

describe('GoogleNews', function () {

    var GoogleNews;

    GoogleNews = require('../index');

    describe('#constructor', function () {
        it('should return a GoogleNews Object', function () {
            should.exist(GoogleNews);
        });
    });
});
