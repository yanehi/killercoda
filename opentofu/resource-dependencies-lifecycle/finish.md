# Summary

Prioritize the use of implicit dependencies whenever possible. Tofu automatically detects these relationships and handles the correct ordering of resource creation, even when output attributes are not yet available. Use explicit dependencies sparingly, limiting them to situations where custom provisioning steps require a specific order that Tofu cannot infer.

Be sure to document any explicit dependencies to provide clarity for other developers.
