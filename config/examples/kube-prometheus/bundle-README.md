# Steps to update the bundle files

```shell
kustomize build . | docker run --rm -i ryane/kfilt -i kind=CustomResourceDefinition > bundle_crd.yaml
kustomize build . | docker run --rm -i ryane/kfilt -x kind=CustomResourceDefinition > bundle.yaml
```
