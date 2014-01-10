path = require 'path'
webdriver = require 'selenium-webdriver'
chai = require 'chai'
chaiWebdriver = require '..'

driver = new webdriver.Builder()
  .withCapabilities(webdriver.Capabilities.chrome())
  .build()

chai.use chaiWebdriver(driver)
{expect} = chai

before ->
  url = "file://#{path.join __dirname, 'test.html'}"
  driver.get url

after ->
  driver.quit()

describe '#text', ->

  it 'can test the text of an element', (done) ->
    expect('h1').dom.to.have.text "The following text is an excerpt from Finnegan's Wake by James Joyce", done
