# WordPress Autoloaded

This is a boilerplate to start a fast WordPress website
without unconditional class loading using [Composer](https://packagist.org/packages/szepeviktor/wordpress-autoloaded).

Core is downloaded from the [official ZIP](https://wordpress.org/download/releases/)
and unconditional class loading is commented out.

### Usage

- Clone [this repository](https://github.com/szepeviktor/wordpress-autoloaded)
- Optionally use `johnpbloch/wordpress` package instead of the included official ZIP,
  see `composer.json` in examples/johnpbloch-wordpress/ directory
- Add plugins e.g. `composer require wpackagist-plugin/wordpress-seo`
- Add your theme
- Prefer class autoloading in theme and plugins,
  simply add the following to composer.json

```json
    "autoload": {
        "psr-4": {
            "MyNamespace\\": "inc/"
        }
    },
    "config": {
        "classmap-authoritative": true
    }
```

### Configuring WordPress

Add Composer autoloader to `app/wp-config.php`

```php
require_once dirname( __DIR__ ) . '/vendor/autoload.php';
```
