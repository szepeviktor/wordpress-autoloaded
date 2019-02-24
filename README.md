# WordPress Autoloaded

This is a boilerplate to start a fast WordPress website
without unconditional class loading using Composer.

Core is downloaded from the [official ZIP](https://wordpress.org/download/releases/)
and unconditional class loading is commented out.

### Configuring WordPress

Add Composer autoload to `app/wp-config.php`

```php
require_once dirname( __DIR__ ) . '/vendor/autoload.php';
```
