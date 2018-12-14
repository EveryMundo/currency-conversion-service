'require strict';

require('./test-setup.js');

const
//   cleanrequire = require('@everymundo/cleanrequire'),
  sinon    = require('sinon'),
  {expect} = require('chai');
  // clone    = arg => JSON.parse(JSON.stringify(arg));

describe('routes/example/get.js', () => {
  const
    logr = require('em-logr'),
    noop = () => {};

  let box;
  beforeEach(() => {
    // creates sinon sandbox
    box = sinon.createSandbox();

    // stubs the logr to stop logging during tests
    ['debug', 'info', 'warn', 'error', 'fatal']
      .forEach((level) => { box.stub(logr, level).callsFake(noop); });
  });

  // retores the sandbox
  afterEach(() => { box.restore(); });


  context('on load', () => {
    it('should export expected keys', () => {
      const route = require('../routes/example/get');

      expect(route).to.have.property('url');
      expect(route).to.have.property('schema');
      expect(route).to.have.property('schema');
      expect(route).to.have.property('handler');
    });
  });

  context('#handler', () => {
    it('should reply with expected input name', (done) => {
      const { handler } = require('../routes/example/get');
      const reply = {
        send(response) {
          expect(response).to.have.property('hello', 'some-name');
          expect(response).to.have.property('obj');

          done();
        },
      };

      const request = {
        query: {name: 'some-name', other: 'otherValue'},
      };

      handler(request, reply);
    });

    it('should reply with default name', (done) => {
      const { handler } = require('../routes/example/get');
      const reply = {
        send(response) {
          expect(response).to.have.property('hello', 'world');
          expect(response).to.have.property('obj');

          done();
        },
      };

      const request = {
        query: {name: undefined, other: 'otherValue'},
      };

      handler(request, reply);
    });
  });
});
