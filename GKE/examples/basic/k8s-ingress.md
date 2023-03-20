# Internal Load Balance HTTP ingress

In order to allow applications in the VPC (outside of the cluster) to access APIs from your kubernetes application, we can use HTTP ingress. 
Behind the scenes, GCP will create a zonal Network Enpoint Group (NEG) to act as a reference for your application pod's IPs and an Internal 
Load Balancer (ILB) that clients can target to reach the application.

*Reference: [ Ingress for Internal HTTP(S) Load Balancing](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress-ilb)*

## Configuring ILB Ingress

Before ILB Ingress resources can be used, the cluster must have the Load Balancer Add on enabled. To do this in the D&B module, set the flag as follows: 

```terraform
module "module_under_test" {
  source = "../.."

  project_id                = var.project_id
  region                    = var.region
  cluster_name              = var.cluster_name
  # Other variables....
  
  enable_http_lb            = true
}
```

This will allow the new ingress resources to create the backing NEG and ILBs when needed. To begin making use of the feature, you will 3 things:
1. An application (a k8s Deployment or Pod works)
    1. A set of pods serving an http application on a given port
2. A K8s service
    1. Serves as a single reference to your application Pods
    1. Manages the NEG 
    1. The type must be NodePort to work
    1. Specify you want a NEG created by using:
    ```yaml
    # my-service.yaml

    apiVersion: v1
    kind: Service
    metadata:
        name: my-service
        annotations:
            cloud.google.com/neg: '{\"ingress\": true}'
    ```
3. An Ingress resource
    1. Allows multiple applications to share the same ILB configuration
    2. Enabling the load balancer add-on above allows you to use the `gce-internal` ingress class
    3. Specify you want to make use an ILB for the ingress by using:
    ```yaml
    # my-ingress.yaml

    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
        name: my-ingress
        annotations:
            kubernetes.io/ingress.class: gce-internal

    ```


## Example Configuration

An example for deploying a kuberentes ingress backed by an HTTP Load balancer has been included in the example in 
`/examples/basic/k8s-ingress.tf`. The example defines a deployment, service, and ingress resource wretten in tf


