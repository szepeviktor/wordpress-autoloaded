# WordPress Autoloaded

A boilerplate to start a fast WordPress website
without unconditional class loading using Composer autoloader.

Core is downloaded from the [official ZIP](https://wordpress.org/download/releases/)
and unconditional class loading is commented out.

:bulb: Please also see [szepeviktor/composer-managed-wordpress](https://github.com/szepeviktor/composer-managed-wordpress)

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
