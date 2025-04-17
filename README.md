# Citrix Workplace LXD container :computer: :arrow_right: :rocket:

Hassle-free and easy installation of Citrix Workspace on Ubuntu 22.04 LTS using LXD.
As of today, Citrix Workspace is not available in the official Ubuntu repositories. Therefore, we need to install it manually. This script automates the installation process and creates a LXD container for Citrix Workspace.

## Prerequisites

None, all is downloaded and installed automatically. It assumes only the following:
- Citrix Workplace 25.03 or compatible version is available for download.
- LXD is installed and configured on your system.
- You may need pass to Launchpad user to cloud-init script run in the LXD container.

## Running the script

Run the following command in your terminal:

```bash

cd terraform
terraform init
terraform apply -var="ssh_user=<your_gh_or_lp_username>"
```
Where \<your\_gh\_or\_lp\_username\> could be in example lp:mastier1 or gh:mastier

Easy-peasy!

When terraform finishes you will see in outputs in example:
```bash
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

citrix-workplace-ipv4 = "10.75.254.182"
connection-help = <<EOT
To connect run:
$ ssh -Y ubuntu@10.75.254.182
Then check with `cloud-init status --wait` . If done start /opt/Citrix/ICAClient/selfservice .
EOT
```

## When world around us changes

In the future the Citrix website may change you might no be able to download the packages automatically
For that reason, the script is designed to be easily modifiable. You can change the URL in the script to point to the new location of the Citrix Workspace package. 
The script will then download and install the package from the new location.

```bash
$ cat terraform/scripts/prepare-citrix.sh
...
icadownload() {
  local PLATFORM=amd64

  wget -q --content-disposition $(
    wget -q -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html | 
    sed -ne '/icaclient_.*'"$PLATFORM"'.*deb/ s/<a .* rel="\(.*\)" id="downloadcomponent_co">/https:\1/p' |
    sed -e 's/\r//g') -P "$TMPDIR"
  wget -q --content-disposition  $(
    wget -q -O - https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html |
      sed -ne '/ctxusb_.*'"$PLATFORM"'.*deb/ s/<a .* rel="\(.*\)" id="downloadcomponent_co.*">/https:\1/p' |
    sed -e 's/\r//g') -P "$TMPDIR"

  echo "$TMPDIR"
}
...
```
