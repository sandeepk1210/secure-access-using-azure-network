# Purpose

Based on the architecture diagram configure secure access to your workloads using Azure networking

![Architecture Diagram](./architecture-diagram.png)

# Step 1 - Create and configure virtual networks

Your organization is migrating a web-based application to Azure. First task is to put in place the virtual networks and subnets. You also need to securely peer the virtual networks.

- Two virtual networks are required, app-vnet and hub-vnet. This simulates a hub and spoke network architecture.
- The app-vnet will host the application. This virtual network requires two subnets. The frontend subnet will host the web servers. The backend subnet will host the database servers.
- The hub-vnet only requires a subnet for the firewall.
- The two virtual networks must be able to communicate with each other securely and privately through virtual network peering.
- Both virtual networks should be in the same region.

# Step 2 - Create and configure network security groups

Your organization requires the network traffic in the app-vnet to be tightly controlled.

- The frontend subnet has web servers that can be accessed from the internet. An application security group (ASG) is required for those servers. The ASG should be associated with any virtual machine interface that is part of the group. This will allow the web servers to be easily managed.
- An NSG rule is required to allow inbound HTTPS traffic to the ASG. This rule uses the TCP protocol on port 443.
- The backend subnet has database servers used by the frontend web servers. A network security group (NSG) is required to control this traffic. The NSG should be associated with any virtual machine interface that will be accessed by the web servers.
- An NSG rule is required to allow inbound network traffic from the ASG to the backend servers. This rule uses the MS SQL service and port 1443.
- For testing, a virtual machine should be installed in the frontend subnet (VM1) and the backend subnet (VM2). The IT group has provided an Azure resource manager template to deploy these Ubuntu servers.

# Step 3 - Create and configure Azure Firewall

Your organization requires centralized network security for the application virtual network. As the application usage increases, more granular application-level filtering and advanced threat protection will be needed. Also, it is expected the application will need continuous updates from Azure DevOps pipelines. You identify these requirements.

Azure Firewall is required for additional security in the app-vnet.
A firewall policy should be configured to help manage access to the application.
A firewall policy application rule is required. This rule will allow the application access to Azure DevOps so the application code can be updated.
A firewall policy network rule is required. This rule will allow DNS resolution.

# Step 4 - Configure network routing

To ensure the firewall policies are enforced, outbound application traffic must be routed through the firewall. You identify these requirements.

A route table is required. This route table will be associated with the frontend and backend subnets.
A route is required to filter all outbound IP traffic from the subnets to the firewall. The firewall’s private IP address will be used.

## Skilling tasks

- Create and configure a route table.
- Link a route table to a subnet.

# Step 5 - Create DNS zones and configure DNS settings

Your organization requires workloads to use domain names instead of IP addresses for internal communications. The organization doesn’t want to add a custom DNS solution. You identify these requirements.

- A private DNS zone is required for contoso.com.
- The DNS will use a virtual network link to app-vnet.
- A new DNS record is required for the backend subnet.

## Skilling tasks

- Create and configure a private DNS zone.
- Create and configure DNS records.
- Configure DNS settings on a virtual network
