# Open edX Devstack on Azure

This is an Azure template to create an Ubuntu VM and provision the Open edX devstack.

You can learn more about Open edX and devstack here:
- https://open.edx.org
- https://github.com/edx/edx-platform

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fchenriksson%2Fopenedx-azure-devstack%2Ftest%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fchenriksson%2Fopenedx-azure-devstack%2Ftest%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template will complete quickly, but the full Open edX install usually takes > 1 hour. To follow along with the progress, ssh into the VM and `tail -f openedx-devstack-install.log`

# Getting started with Open edX devstack
After the initial provisioning has completed, ssh into your vm with:
`ssh vagrant@YOUR_INSTANCES_DNS_NAME.cloudapp.azure.com`

and authenticate with the password specified in:
`ADMINPASSWORD`

From here, switch into the edxapp user:
```
sudo su edxapp -s /bin/bash
source /edx/app/edxapp/edxapp_env
```

To get your server up and running navigate to the edx-platform directory:
```
cd /edx/app/edxapp/edx-platform
````

and use `paver` to help you start either the LMS (student facing site):
```
paver devstack lms
```

or Studio (the course authoring site):
```
paver devstack studio
```

After that, you can visit the sites by opening your browser and navigating to `YOUR_INSTANCES_DNS_NAME.cloudapp.azure.com:8000` for the LMS and `YOUR_INSTANCES_DNS_NAME.cloudapp.azure.com:8001` for Studio.

For more info, check the [Open edX Github Wiki on devstack](https://github.com/edx/configuration/wiki/edX-Developer-Stack)