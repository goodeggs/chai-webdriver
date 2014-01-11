chai-webdriver
==============

[![NPM](https://nodei.co/npm/chai-webdriver.png?compact=true)](https://nodei.co/npm/chai-webdriver/)

[![Dependency Status](https://david-dm.org/goodeggs/chai-webdriver.png)](https://david-dm.org/goodeggs/chai-webdriver)

Build more expressive integration tests with some [selenium-webdriver](https://npmjs.org/package/selenium-webdriver) sugar for the [Chai Assertion Library](http://chaijs.com/).

Allows for assertions that look like this:

```javascript
expect('.frequency-field').dom.to.contain.text('One time')
expect('.toggle-pane').dom.to.not.be.visible()
```

## What sorts of assertions can we make?

All assertions start with a css selector, for example:

- `expect('.list')`
- `expect('div > h1')`
- `expect('a[href=http://google.com]')`

Then we add the dom flag, like so:

- `expect(selector).dom`

Finally, we can add our assertion to the chain:

- `expect(selector).dom.to.have.text('string')` - Test the text value of the dom against supplied string. Exact matches only.
- `expect(selector).dom.to.contains.text('string')` - Test the text value of the dom against supplied string. Partial matches allowed.
- `expect(selector).dom.to.be.visible()` - Check whether or not the element is being rendered
- `expect(selector).dom.to.be.disabled()` - Check whether or not the form element is disabled
- `expect(selector).dom.to.have.count(number)` - Test how many elements exist in the dom with the supplied selector
- `expect(selector).dom.to.have.style('property', 'value')` - Test the CSS style of the element. Exact matches only, unfortunately, for now.
- `expect(selector).dom.to.have.value('string')` - Test the value of a form field against supplied string.

You can also always add a `not` in there to negate the assertion:

- `expect(selector).dom.not.to.have.style('property', 'value')`

## Caveats

Right now, we inject an instance of [Sizzle.js](http://sizzlejs.com/) onto the page to ease selection. This is not ideal because it might clobber stuff, but it's a start. And odds are it won't change anything for you.

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
chai.use chaiWebdriver(driver);

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
