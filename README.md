# Parse Helm templates

Helm is a very useful tool that enables the definition of Kubernetes objects as a template. However, some
Helm charts can become big and complex making the installation setup difficult. Hundreds of
variables in the values file that tweak the deployment add complexity.

You can output to a file the helm debug and pass them to the script `clean-and-build.sh` to have your
manifests.

This repo expects that output of the `helm template chart --name Name --debug` and parses the output
to hardcoded manifests. 

# Example

Download a Helm Chart
```
git clone https://github.com/storageos/helm-chart.git storageos
```

Run the template builder
```
cd storageos
helm template . -n v1 --set cluster.join=$(storageos cluster create) --set csi.enable=true --debug > /tmp/out
```

Execute the parser
```
 ~/repos/curate-helm-output # ./clean-and-build.sh /tmp/out
 You can find your files in ./output/2018-08-10-1445
 ~/repos/curate-helm-output # cd ./output/2018-08-10-1445 && ls
 daemonset_csi.yaml  namespace.yaml  runtime-variables  secrets.yaml  setup_csi.yaml statefulset_csi.yaml  svc.yaml  tests
```

