#########################################################################################
#                                                                                       #
#  Environment definitions                                                              #
#                                                                                       #
#########################################################################################

# The subscription_id value is a mandatory field, it is used to control where the resources are deployed
subscription_id = "d6c8e3b6-467e-452e-97c9-49d9de9e37da"

# The environment value is a mandatory field, it is used for partitioning the environments, for example (PROD and NON-PROD)
environment = "TEST"

# The location value is a mandatory field, it is used to control where the resources are deployed
location = "eastus"

# The virtaul_network_id value is a mandatory field, it is used to control where the resources are deployed
virtual_network_id = "/subscriptions/d6c8e3b6-467e-452e-97c9-49d9de9e37da/resourceGroups/SAPContosoInfra/providers/Microsoft.Network/virtualNetworks/SAPContosoVNET"

# The subnet address prefix value is a mandatory field, it is used to control where the resources are deployed
subnet_address_prefixes = "10.19.4.0/28"

resource_group_tags = {
    "CreatedBy": "SAPonAzureBgPrint",
}