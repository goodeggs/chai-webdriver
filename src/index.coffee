fs = require 'fs'
string = require 'string'
seleniumWebdriver = require 'selenium-webdriver'
sizzle = require 'webdriver-sizzle'

module.exports = chaiWebdriver = (driver) ->

  $ = sizzle(driver)

  (chai, utils) ->
    assertElementExists = (selector, done) ->
      $.all(selector).then (els) ->
        if els.length is 0
          throw new Error "Could not find element with selector #{selector}"
        else
          done()

    chai.Assertion.addProperty 'dom', ->
      utils.flag @, 'dom', true

    chai.Assertion.overwriteMethod 'match', (_super) ->
      (matcher, done) ->
        if utils.flag @, 'dom'
          assertElementExists @_obj, =>
            $(@_obj).getText().then (text) =>
              @assert matcher.test(text),
                'Expected element <#{this}> to match regular expression "#{exp}", but it contains "#{act}".'
                'Expected element <#{this}> not to match regular expression "#{exp}"; it contains "#{act}".'
                matcher, text
              done?()
        else
          _super.call @, matcher

    chai.Assertion.addMethod 'visible', (done) ->
      throw new Error('Can only test visibility of dom elements') unless utils.flag @, 'dom'

      assert = (condition) =>
        @assert condition,
          'Expected #{this} to be visible but it is not',
          'Expected #{this} to not be visible but it is'
        done?()

      assertDisplayed = =>
        $(@_obj).isDisplayed().then (visible) -> assert(visible)

      if utils.flag(@, 'negate')
        $.all(@_obj).then (els) ->
          if els.length > 0
            assertDisplayed()
          else
            assert(els.length > 0)
      else
        assertDisplayed()

    chai.Assertion.addMethod 'count', (length, done) ->
      throw new Error('Can only test count of dom elements') unless utils.flag @, 'dom'
      $.all(@_obj).then (els) =>
        @assert els.length is length,
          'Expected #{this} to appear in the DOM #{exp} times, but it shows up #{act} times instead.'
          'Expected #{this} not to appear in the DOM #{exp} times, but it does.'
          length, els.length
        done?()

    chai.Assertion.addMethod 'text', (matcher, done) ->
      throw new Error('Can only test text of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        $(@_obj).getText().then (text) =>
          if matcher instanceof RegExp
            @assert matcher.test(text),
              'Expected element <#{this}> to match regular expression "#{exp}", but it contains "#{act}".'
              'Expected element <#{this}> not to match regular expression "#{exp}"; it contains "#{act}".'
              matcher, text
          else if utils.flag @, 'contains'
            @assert ~text.indexOf(matcher),
              'Expected element <#{this}> to contain text "#{exp}", but it contains "#{act}" instead.'
              'Expected element <#{this}> not to contain text "#{exp}", but it contains "#{act}".'
              matcher, text
          else
            @assert text is matcher,
              'Expected text of element <#{this}> to be "#{exp}", but it was "#{act}" instead.'
              'Expected text of element <#{this}> not to be "#{exp}", but it was.'
              matcher, text
          done?()

    chai.Assertion.addMethod 'style', (property, value, done) ->
      throw new Error('Can only test style of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        $(@_obj).getCssValue(property).then (style) =>
          @assert style is value,
            "Expected #{property} of element <#{@_obj}> to be '#{value}', but it is '#{style}'.",
            "Expected #{property} of element <#{@_obj}> to not be '#{value}', but it is.",
          done?()

    chai.Assertion.addMethod 'value', (value, done) ->
      throw new Error('Can only test value of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        $(@_obj).getAttribute('value').then (actualValue) =>
          @assert value is actualValue,
            "Expected value of element <#{@_obj}> to be '#{value}', but it is '#{actualValue}'.",
            "Expected value of element <#{@_obj}> to not be '#{value}', but it is.",
          done?()

    chai.Assertion.addMethod 'disabled', (done) ->
      throw new Error('Can only test value of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        $(@_obj).getAttribute('disabled').then (disabled) =>
          @assert disabled,
            'Expected #{this} to be disabled but it is not',
            'Expected #{this} to not be disabled but it is'
          done?()

    chai.Assertion.addMethod 'htmlClass', (value, done) ->
      throw new Error('Can only test value of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        $(@_obj).getAttribute('class').then (classList) =>
          @assert ~classList.indexOf(value),
            "Expected #{classList} to contain #{value}, but it does not."
          done?()

    chai.Assertion.addMethod 'attribute', (attribute, value, done) ->
      throw new Error('Can only test style of dom elements') unless utils.flag @, 'dom'
      assertElementExists @_obj, =>
        $(@_obj).getAttribute(attribute).then (actual) =>
          if typeof value is 'function'
            done = value
            @assert typeof actual is 'string',
              "Expected attribute #{attribute} of element <#{@_obj}> to exist",
              "Expected attribute #{attribute} of element <#{@_obj}> to not exist",
            done?()
          else
            @assert actual is value,
              "Expected attribute #{attribute} of element <#{@_obj}> to be '#{value}', but it is '#{actual}'.",
              "Expected attribute #{attribute} of element <#{@_obj}> to not be '#{value}', but it is.",
            done?()
