# Infrastructure via Azure

Here are the items we'll need for the installation:

+ Azure Kubernetes Service (AKS)
+ Azure Application Gateway
+ Virtual Network Gateway (VPN)

**NOTE:** The manual guides users through configuring settings via the Azure Portal interface


## Before you begin
You need subscriptions associated with your account.  Once logged in, you'll see a list of subscriptions. Select the subscription where you want to deploy your resources.

## Configuration
### 1. Create Resource Group (RG)
Log in to the Azure portal and navigate to the Resource Groups section.
Create a new resource group to contain your associated resources:

1. Click the "Create" button.

2. Choose your subscription plan.

3. Select a Region, such as *East US*.

4. Assign a name to your Resource Group, such as *someResourceGroup* proceed by clicking "Review + create"

5. Once validation passed, complete the process by clicking “Create.”


### 2. AKS configuration
[Azure Docs](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-portal)

1. On the Azure portal home page, select "Create a resource".


2. In the "Categories" section, select "Containers" > "Azure Kubernetes Service (AKS)".


3. On the **Basics** tab configure the following options:

    1. Choose **Subscription** and **Resource group** such as mentioned earlier (*someResourceGroup*).

    2. Set the **Cluster preset configuration** to *Dev/Test*.

    3. Enter a **Kubernetes cluster name** such as *someAKS*.

    4. Select a **Region** for the AKS cluster, such as *East US*.

    5. Set the **Availability zones** to *None*.

    6. Set the **AKS pricing** tier to *Free*.

    7. Set the *1.28.5* value selected for **Kubernetes version**.

    8. Leave the **Automatic upgrade setting** set to the recommended value, which is *Enabled with patch*.

    9. Leave the **Node security channel type** set no the *Node image*.

    10. Leave the **Authentication and authorization setting** set to *Local accounts with Kubernetes RBAC*.

    11. Click "Next".


4. On the **Node pools** tab, add a new node pool:

    1. Select **Add node pool**.

        1. Enter a **Node pool name**, such as *workload*.

        2. For **Mode**, select *User*.

        3. For **OS SKU**, select *Ubuntu Linux*.

        4. Set the **Availability zones** setting to *None*.

        5. Leave the **Enable Azure Spot instances** checkbox unchecked.

        6. For **Node size**, click "Choose a size". On the **Select a VM size** page, select *Standard_E4s_v3*, then choose the "Select" button.

        7. Leave the **Scale method** setting set to *Autoscale*.

        8. Leave the **Minimum node count** and **Maximum node count** fields set to their default settings.

        9. Set the **Max pods per node** to *30*.

        10. Leave the **Taints** and **Labels** fields empty and click to the "Add" button.

    2. Leave the **Enable virtual nodes** checkbox unchecked.

    3. Leave the **Encryption type** set to the default value, which is *Encryption at-rest with a platform-managed key*.

    4. Click "Next".


5. On the **Networking** tab, configure the options:
    
    1. Select the **Enable private cluster** checkbox. The cluster will not be accessible from the public internet.

    2. Leave the **Set authorized IP ranges** checkbox unchecked.

    3. Set the **Network configuration** to *Azure CNI*

    4. Select the **Bring your own virtual network** checkbox and create your own VNet by clicking "Create new":

      1. Enter a **Name**, such as *someAKSVNet*.

      2. Choose the same **Resource group** as in the "Basic" tab (*someResourceGroup*).

      3. Add to the **Address space** an address range *10.2.0.0/21*.

      4. Add subnet to the **Subnets** with range *10.2.0.0/23* and click "Ok".

    5. Check if contains name of the subnet created on the previous step. Default name is *default*.

    6. Verify whether the **Cluster subnet** field is populated with the same name of the subnet created in the previous step. By default, the subnet is named *default*.
    
    7. Leave the **Kubernetes service address range** and **Kubernetes DNS service IP address** set to default, *10.0.0.0/16* and *10.0.0.10* respectively.
    
    8. Set the **DNS name prefix** to *some2AKSCluster-dns*.
    
    9. Switch the **Network policy** to *Calico* and click "Next".

6. Configure integrations:

    1. Leave the **Enable Istio** checkbox unchecked.

    2. Leave the **Azure Policy** disabled ([learn more](https://learn.microsoft.com/en-gb/azure/governance/policy/concepts/policy-for-kubernetes)).

    3. Click "Next".

7. Configure monitoring:

    1. Leave the **Enable Container Logs** checkbox unchecked.

    2. Disable **Enable Prometheus metrics** and **Enable Grafana** checkboxes.

    3. Leave the **Enable recommended alert rules** checkbox checked and click "Review + create".

8. If validation passed, click "Create". Else check errors and retry.


### 3. Application Gateway

1. On the Azure portal home page, select "Create a resource".

2. In the "Categories" section, select "Networking" > "Application Gateway".

3. On the **Basics** tab configure the following options:

    1. Select **Subscription** and **Resource group** such as mentioned earlier (*someResourceGroup*).

    2. Enter a **Application gateway name** such as *someAppGateway*.

    3. Select a **Region**, such as *East US*.

    4. Select a **Tier**, such as *WAF V2*.

    5. Set the **Enable autoscaling** to *No*.

    6. Set the **Instance count** value to *1*.

    7. Leave the **Availability zones*** as default (Checked all zones).

    8. Set the **HTTP2** to *Disabled*.

    9. Select or create new **WAF Policy** such as *someWebAppWAFPolicy*.

    10. Set the **IP address type** to *IPv4 only*.

    11. Select **Virtual network**, such as *someAKSVNet* (created with AKS).

    12. Click "Manage subnet configuration" and create subnet with name and address range, such as *AppGatewaySubNet* and *10.2.4.0/24* respectively. Close "Subnets" page by clicking [x] on the right top of the page.

    13. Select created subnet on the **Subnet** field and click "Next: Frontends>". 

4. Configure Frontend IP addresses:
    1. Set the **Frontend IP address type** to *Both*.
    
    2. Create new public IP by clicking "Add new". Set name such as *appGwPrivateFrontendIpIPv4* and confirm by clicking "Ok".
    
    3. Assign to the **Private IPv4 address** address from the assigned subnet range, such as *10.2.4.10* and and click "Next: Backends>". 

5. Configure Backend pools:
    
    1. Click to "Add a backend pool".

    2. Set name such as *AKSCluster* and assign IP address such as 10.2.0.203 
        >  IP address of the backend target depends on EXTERNAL-IP of K8s LoadBalancer service.
        >
        >  To check assigned IP, describe your proxy service:
        >
        >  `kubectl get service -n <NAMESPACE> proxy`

    3. Click "Next: Configuration>".

6. Bind Frontend to Backend and configure routing rules:

    1. Click "Add a routing rule".

    2. Set **Rule name** such as *some2AppGatewayRoutingRule*.

    3. Set priority such as *10*.

    4. On the "Listener" tab configure listener:

        1. Set **Listener name** such as *some2AppGatewayListener*.

        2. Set to the **Frontend IP** *Private IPv4*

        3. Switch the **Protocol** to *HTTPS*

        4. Set *443* to the **Port** field

        5. Assign certificate. Set **Cert name** as such *some-cert*, **Managed identity** such as someCertIdentity,
        **Key Vault** such as *some2Keyvault* and select appropriate **Certificate** by name (*some-cert*)
            > It's able to add certificate directly to ApplicationGateway. 
            > Azure Key Vaul configuration and certificate import described [here](./azure_keyvault.md)

        6. Leave the **Listener type** on "Basic".


    > TODO Add link to Key vault configuration + *.pfx certificate generation

    5. On the "Backend targets" tab configure backend pool:

        1. Select *Backend pool* to the **Target type**.

        2. Select **Backend target** created earlier such as *AKSCluster*.

        3. Add **Backend settings** by clicking "Add new".

            1. Set **Backend settings name** such as *AKSClusterSettings*.

            2. **Backend protocol** to *HTTP*

            3. **Backend port** set to port 8081 (proxy service listens this post)

            4. Disable **Cookie-based affinity** and **Connection draining**

            5. **Request time-out** set to *60*.

            6. Leave **Override backend path** value empty.

            7. **Override with new host name** set to *No*.

        4. Confirm by clicking "Add".
    
    6. Click "Next" and "Review + create". If validation passed, click "Create".


### 4. Configure VPN

1. On the Azure portal home page, select "Create a resource".

2. In the "Categories" section, select "Networking" > "Virtual Network Gateway".

3. On the **Basics** tab configure the following options:

    1. Enter a **Application gateway name** such as *someAppGateway*.

    2. Select a **Region**, such as *East US*.

    3. Choose **Gateway type** to *VPN*.

    4. **SKU** to *VpnGw2AZ*.

    5. **Generation** to *Generation2*

    5. Select **Virtual network** such as mentioned earlier (*someAKSVNet*).

    6. Set **Gateway subnet address range** such as *10.2.3.0/26*.

    7. Create new **Public IP address**:

        1. Set name.

        2. **Availability zones** to *1*

    8. Disable **Enable active-active mode** and **Configure BGP**.

4. Click "Review + create". If validation passed, click "Create".

5. Go to the created resource by clicking 
