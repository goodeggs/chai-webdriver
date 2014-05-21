# chai-webdriver [![Build Status](https://travis-ci.org/goodeggs/chai-webdriver.png)](https://travis-ci.org/goodeggs/chai-webdriver) [![Dependency Status](https://david-dm.org/goodeggs/chai-webdriver.png)](https://david-dm.org/goodeggs/chai-webdriver) [![NPM version](https://badge.fury.io/js/chai-webdriver.png)](http://badge.fury.io/js/chai-webdriver)

Provides [selenium-webdriver](https://npmjs.org/package/selenium-webdriver) sugar for the [Chai](http://chaijs.com/) assertion library. Allows you to create expressive integration tests:

```javascript
expect('.frequency-field').dom.to.contain.text('One time')
expect('.toggle-pane').dom.to.not.be.visible()
```

## What sorts of assertions can we make?

All assertions start with a [Sizzle-compatible css selector](http://sizzlejs.com/), for example:

- `expect('.list')`
- `expect('div > h1')`
- `expect('a[href=http://google.com]')`

Then we add the dom flag, like so:

- `expect(selector).dom`

Finally, we can add our assertion to the chain:

- `expect(selector).dom.to.have.text('string')` - Test the text value of the dom against supplied string. Exact matches only.
- `expect(selector).dom.to.contain.text('string')` - Test the text value of the dom against supplied string. Partial matches allowed.
- `expect(selector).dom.to.match(/regex/)` - Test the text value of the dom against the regular expression.
- `expect(selector).dom.to.have.text(/regex/)` - Test the text value of the dom against the regular expression. (Same as `match` above).
- `expect(selector).dom.to.be.visible()` - Check whether or not the element is being rendered
- `expect(selector).dom.to.be.disabled()` - Check whether or not the form element is disabled
- `expect(selector).dom.to.have.count(number)` - Test how many elements exist in the dom with the supplied selector
- `expect(selector).dom.to.have.style('property', 'value')` - Test the CSS style of the element. Exact matches only, unfortunately, for now.
- `expect(selector).dom.to.have.value('string')` - Test the value of a form field against supplied string.
- `expect(selector).dom.to.have.htmlClass('warning')` - Tests that the element has `warning` as one of its class attributes.
- `expect(selector).dom.to.have.attribute('attribute', 'value')` - Test an element's attribute value. Exact matches only. By omitting `value` test simply checks for existance of attribute.

You can also always add a `not` in there to negate the assertion:

- `expect(selector).dom.not.to.have.style('property', 'value')`

## Setup

Setup is pretty easy. Just:

```javascript

// Start with a webdriver instance:
var sw = require('selenium-webdriver');
var driver = new sw.Builder()
  .withCapabilities(sw.Capabilities.chrome())
  .build()

// And then...
var chai = require('chai');
var chaiWebdriver = require('chai-webdriver');
chai.use(chaiWebdriver(driver));

// And you're good to go!
driver.get('http://github.com');
chai.expect('#site-container h1.heading').dom.to.not.contain.text("I'm a kitty!");
```

## Contributing

so easy.

```bash
npm install           # download the neccesary development dependencies
npm run-script build  # compile coffee-script into javascript
npm test              # build and run the specs
```

## License

MIT.
