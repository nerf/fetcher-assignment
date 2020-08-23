require './config/boot'

use Rack::Cache,
    verbose: true,
    metastore: 'memcached://localhost',
    entitystore: 'memcached://localhost'

run Application
