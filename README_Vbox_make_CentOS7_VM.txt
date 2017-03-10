# Instructions for creating CentOS-7 VM on Windows.

On your computer, install Oracle VirtualBox.
Accept all defaults.

After install, run the Oracle VM VirtualBox Manager.

# -------------------
# In the Vbox Manager:
# -------------------

Create a new VM.
    Click the blue button at top left that says "New"
        Name: Give your VM a unique name, e.g., "CentOS7 for Tamara"
        Type: Select "Linux"
        Version: Select "Other Linux (64-bit)"
        Click Next
    Enter "1024" MB RAM (or more)
        Click Next
    Select "Create a virtual hard disk now"
        Click Create
    Select "VDI (VirtualBox Disk Image)"
        Click Next
    Select "Dynamically allocated"
        Click Next
    Enter "8.00 GB" (or more)
        Click Create

Double click the VM to start it for the first time
Wait for the popup window that says "Select start-up disk"

# -------------------
# In the popup window:
# -------------------

Click the small yellow folder icon on lower right of window
    In the popup explorer window, locate the "CentOS-7-x86_64-DVD-1611.iso" file
    Click Open
Click Start
A new CentOS Linux 7 VM window will open

# ---------
# On the VM:
# ---------

Use the up/down arrows on keyboard to highlight "Install CentOS Linux 7"
Hit the Enter key
Use your mouse to select OS options
    **** Set a NON-BLANK root password during install process
    **** Create a user with Admin priv during install process
Click REBOOT
Login with username and password created during install process
At the command prompt, type "init 0" to shutdown the VM

# -------------------
# In the Vbox Manager:
# -------------------

Configure the VM network settings
    Highlight the new VM
    Click the orange button at top left that says "Settings"

# ----------------------
# In the settings window:
# ----------------------

Click System
    On Motherboard tab:
        Unclick Floppy

Click USB
    Unclick Enable USB Controller

Click Network
    On Adapter 2 tab:
        Click Enable Network Adapter
        Attached to: Host-only Adapter
Click OK

# --------
# OPTIONAL:
# --------
# If you want to network several VMs, you need to
# create a new host-only network with no DHCP server
# and enable a host-only adapter in a new VM's network slot.

# On the VM:
# Check status of NetworkManager.service
    systemctl status NetworkManager.service
# Check status of devices
    nmcli dev status
# Ensure ethernet adaptor in use
    ip addr
# Check for existing device config files
    ls /etc/sysconfig/network-scripts/
# Gen a UUID for the new dev
    uuidgen enp0s8 >> /etc/sysconfig/network-scripts/ifcfg-enp0s8
# Modify both config files - Remove all but the following lines.
    ifcfg-enp0s8                    ifcfg-enp0s3
    ------------                    ------------
    DEVICE=enp0s8                   DEVICE=enp0s3
    NAME="Wired connection 2"       NAME="Wired connection 1"
    TYPE=Ethernet                   TYPE=Ethernet
    BOOTPROTO=static                BOOTPROTO=dhcp
    IPADDR=192.168.98.101           IPADDR=10.0.3.31
    NETMASK=255.255.255.0           NETMASK=255.255.255.0
    NM_CONTROLLED=yes               NM_CONTROLLED=yes
    ONBOOT=yes                      ONBOOT=yes
    HWADDR=xx:xx:xx:xx:xx:xx        HWADDR=xx:xx:xx:xx:xx:xx
    UUID=<UUID from prev step>      UUID=<existing UUID or new one from prev step>

# restart the service
    systemctl restart network.service


