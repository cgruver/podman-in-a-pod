# podman-in-a-pod

1. As cluster admin -

   ```bash
   oc apply -f podman-scc.yaml
   oc adm policy add-scc-to-user podman-scc <non-admin-user>
   ```

1. As a non-admin-user

   ```bash
   oc new-project podman-test
   oc apply -f imageConfigMap.yaml
   oc apply -f pod.yaml
   oc logs podman
   oc delete pod podman
   ```
