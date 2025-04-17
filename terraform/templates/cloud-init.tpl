#cloud-config

package_update: true
package_upgrade: true
ssh_import_id:
  - ${ssh_user}

write_files:
  - owner: root:root
    path: /tmp/prepare-citrix.sh
    permissions: '0755'
    content: |-
      ${indent(6,citrix_script)}

runcmd:
  - /tmp/prepare-citrix.sh 
  - rm -f /tmp/prepare-citrix.sh
