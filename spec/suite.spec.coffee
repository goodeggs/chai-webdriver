path = require 'path'
webdriver = require 'selenium-webdriver'
chai = require 'chai'
chaiWebdriver = require '..'

webdriver.logging = LevelName: 'DEBUG' # this seems like a bug in webdriver...

driver = new webdriver.Builder()
  .withCapabilities(webdriver.Capabilities.phantomjs())
  .build()

chai.use chaiWebdriver(driver)
{expect} = chai

url = (page) ->
  "file://#{path.join __dirname, page}"

after (done) ->
  driver.quit().then -> done()

describe 'the basics', ->

  before (done) ->
    @timeout 0 # this may take a while in CI
    driver.get(url 'finnegan.html').then -> done()

  describe '#text', ->
    it 'verifies that an element has exact text', (done) ->
      expect('h1').dom.to.have.text "The following text is an excerpt from Finnegan's Wake by James Joyce", done

    it 'verifies that an element does not have exact text', (done) ->
      expect('h1').dom.not.to.have.text "Wake", done

  describe '#text (regexp version)', ->
    it 'verifies that an element has a regexp match', (done) ->
      expect('h1').dom.to.have.text /following.*excerpt/, done

    it 'verifies that an element does not match the regexp', (done) ->
      expect('h1').dom.not.to.have.text /following.*food/, done

  describe '#contain', ->
    describe 'on a dom element', ->
      it 'verifies that an element contains text', (done) ->
        expect('h1').dom.to.contain.text "Finnegan", done

      it 'verifies that an element does not contain text', (done) ->
        expect('h1').dom.not.to.contain.text "Bibimbap", done

    describe 'not on a dom element', ->
      it 'verifies that a string contains text', ->
        expect('John Finnegan').to.contain "Finnegan"

      it 'verifies that a string does not contain text', ->
        expect('John Finnegan').dom.not.to.contain "Bibimbap"

  describe '#match', ->
    it 'verifies that an element has a regexp match', (done) ->
      expect('h1').dom.to.match /following.*excerpt/, done

    it 'verifies that an element does not match the regexp', (done) ->
      expect('h1').dom.not.to.match /following.*food/, done

    describe 'not on a dom element', ->
      it 'verifies that a string does match the regexp', ->
        expect('some test text').to.match /test/

      it 'verifies that a string does not match the regexp', ->
        expect('some test text').not.to.match /taste/

  describe '#visible', ->
    it 'verifies that an element is visible', (done) ->
      expect('.does-exist:text').dom.to.be.visible done

    it 'verifies that a non-existing element is not visible', (done) ->
      expect('.does-not-exist').dom.not.to.be.visible done

    it 'verifies that a hidden element is not visible', (done) ->
      expect('.exists-but-hidden').dom.not.to.be.visible done

  describe '#count', ->
    it 'verifies that an element appears thrice', (done) ->
      expect('input').dom.to.have.count 3, done

    it 'verifies that a non-existing element has a count of 0', (done) ->
      expect('.does-not-exist').dom.to.have.count 0, done

  describe '#style', ->
    it 'verifies that an element has a red background', (done) ->
      expect('.red-bg').dom.to.have.style 'background-color', 'rgba(255, 0, 0, 1)', done

    it 'verifies that an element does not have a red background', (done) ->
      expect('.green-text').dom.to.have.style 'background-color', 'rgba(0, 0, 0, 0)', done

  describe '#value', ->
    it 'verifies that a text field has a specific value', (done) ->
      expect('.does-exist').dom.to.have.value 'People put stuff here', done

    it 'verifies that a text field does not have a specific value', (done) ->
      expect('.does-exist').dom.not.to.have.value 'Beep boop', done

  describe '#disabled', ->
    it 'verifies that an input is disabled', (done) ->
      expect('.i-am-disabled').dom.to.be.disabled done

    it 'verifies that an input is not disabled', (done) ->
      expect('.does-exist').dom.not.to.be.disabled done

  describe 'htmlClass', ->
    it 'verifies that an element has a given class', (done) ->
      expect('.does-exist').dom.to.have.htmlClass 'second-class', done

    it 'verifies than an element does not have a given class', (done) ->
      expect('.green-text').dom.not.to.have.htmlClass 'second-class', done

  describe 'attribute', ->
    it 'verifies that an element attribute has a given value', (done) ->
        expect('input.does-exist').dom.to.have.attribute 'value', 'People put stuff here', done

    it 'verifies that an element attribute does not have a given value', (done) ->
        expect('input.does-exist').dom.not.to.have.attribute 'input', 'radio', done

    it 'verifies that an attribute does not exist', (done) ->
        expect('input.does-exist').dom.not.to.have.attribute 'href', done

    it 'verifies that an attribute exists', (done) ->
        expect('input.does-exist').dom.to.have.attribute 'type', done

    it 'verifies that an empty attribute exists', (done) ->
        expect('input.does-exist').dom.to.have.attribute 'empty', done

describe 'going to a different page', ->
  before (done) ->
    @timeout 0
    driver.get(url 'link.html')
    driver.findElement(webdriver.By.name('link')).click().then -> done()

  it 'still allows you to make assertions', (done) ->
    expect('.does-exist:text').dom.to.to.be.visible done
