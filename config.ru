require './config/boot'

use Rack::Cache,
    verbose: true,
    metastore: 'memcached://memcached',
    entitystore: 'memcached://memcached'

run Application
