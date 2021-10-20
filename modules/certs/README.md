# Certs

## Creating certs for new domains

Creating certs for new domains can be a bit of a faff.

This is because of a circular dependency between the Route 53 zone (which needs to know about any upstream resources
that use certs (Cloudfront, LBs, etc.)), the ACME certificate validator (which needs a Route 53 zone to create the
challenge on), and the upstream resources (that need certificates before they can be created).

The current workaround:

1. Create the zone without pointing it to any resources
1. Create and validate the cert against the empty zone
1. Create the upstream resources using the cert
1. Update the zone to point to the upstream resources

## Updating certs

This is also a bit of a pain as after the new certs are created in ACM, tf won't be able to delete the olds ones if
they're in use by ECS/EC2/Cloudfront. The process is:

1. Run the `certs` stack to renew the certs
2. Cancel the job when it hangs trying to destroy the old certs
3. Run the `ecs/ec2/cloudfront` stacks that are using the old certs. They'll switch to the new ones
4. Re-run the `certs` stack and the old certs will be deleted

## Why the us-east-1 provider?

At time of writing Cloudfront still only supports using certificates located in the us-east-1 region so we configure 
another AWS provider with the us-east-1 region and use it via the useast alias.
