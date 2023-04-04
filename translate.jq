[
  select(.schema == "olm.bundle").properties[]
  | select(.type == "olm.bundle.object")
]
| map(.value.data | @base64d | fromjson)
| .[]
| select(.kind == "ClusterServiceVersion")
| [
    .spec.displayName,
    .metadata.name,
    .spec.provider.name,
    .metadata.annotations."operators.openshift.io/valid-subscription",
    .metadata.annotations.support
  ]
| @csv
