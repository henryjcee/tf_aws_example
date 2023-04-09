# Certs

## Why the us-east-1 provider?

At time of writing Cloudfront still only supports using certificates located in the us-east-1 region so we configure 
another AWS provider with the us-east-1 region and use it via the useast alias.
