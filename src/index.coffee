fs = require 'fs'
string = require 'string'
uglify = require 'uglify-js'
seleniumWebdriver = require 'selenium-webdriver'
sizzleCode = uglify.minify(fs.readFileSync(require.resolve('sizzle'), 'utf8'), fromString: yes).code

addSizzle = (driver) ->
  {get} = driver
  driver.get = ->
    get.apply(driver, arguments).then ->
      driver.executeScript sizzleCode

module.exports = (driver) ->
  addSizzle driver

  findElementByCss = (css) ->
    driver.findElement seleniumWebdriver.By.js((css) -> (Sizzle(css) or [])[0]), css

  findElementsByCss = (css) ->
    driver.findElements seleniumWebdriver.By.js((css) -> Sizzle(css) or []), css

  (chai, utils) ->
    assertElementExists = (selector, done) ->
      findElementsByCss(selector).then (els) ->
        if els.length is 0
          throw new Error "Could not find element with selector #{selector}"
        else
          done()

    chai.Assertion.addProperty 'dom', ->
      utils.flag @, 'dom', true

    chai.Assertion.addMethod 'visible', (done) ->
      throw new Error('Can only test visibility of dom elements') unless utils.flag @, 'dom'

      assert = (condition) =>
        @assert condition,
          'Expected #{this} to be visible but it is not',
          'Expected #{this} to not be visible but it is'
        done() if typeof done is 'function'

      assertDisplayed = =>
        findElementByCss(@_obj).isDisplayed().then (visible) -> assert(visible)

      if utils.flag(@, 'negate')
        findElementsByCss(@_obj).then (els) ->
          if els.length > 0
            assertDisplayed()
          else
            assert(els.length > 0)
      else
        assertDisplayed()

    chai.Assertion.addMethod 'count', (length, done) ->
      throw new Error('Can only test count of dom elements') unless utils.flag @, 'dom'
      findElementsByCss(@_obj).then (els) =>
        @assert els.length is length,
          'Expected #{this} to appear in the DOM #{exp} times, but it shows up #{act} times instead.'
          'Expected #{this} not to appear in the DOM #{exp} times, but it does.'
          length, els.length
        done() if typeof done is 'function'

    chai.Assertion.addMethod 'text', (matcher, done) ->
      throw new Error('Can only test text of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        findElementByCss(@_obj).getText().then (text) =>
          if utils.flag @, 'contains'
            @assert ~text.indexOf(matcher),
              'Expected element <#{this}> to contain text "#{exp}", but it contains "#{act}" instead.'
              'Expected element <#{this}> not to contain text "#{exp}", but it contains "#{act}".'
              matcher, text
          else
            @assert text is matcher,
              'Expected text of element <#{this}> to be "#{exp}", but it was "#{act}" instead.'
              'Expected text of element <#{this}> not to be "#{exp}", but it was.'
              matcher, text
          done() if typeof done is 'function'

    chai.Assertion.addMethod 'style', (property, value, done) ->
      throw new Error('Can only test style of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        findElementByCss(@_obj).getCssValue(property).then (style) =>
          @assert style is value,
            "Expected #{property} of element <#{@_obj}> to be '#{value}', but it is '#{style}'.",
            "Expected #{property} of element <#{@_obj}> to not be '#{value}', but it is.",
          done() if typeof done is 'function'

    chai.Assertion.addMethod 'value', (value, done) ->
      throw new Error('Can only test value of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        findElementByCss(@_obj).getAttribute('value').then (actualValue) =>
          @assert value is actualValue,
            "Expected value of element <#{@_obj}> to be '#{value}', but it is '#{actualValue}'.",
            "Expected value of element <#{@_obj}> to not be '#{value}', but it is.",
          done() if typeof done is 'function'
