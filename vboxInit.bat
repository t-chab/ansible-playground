REM ###################################################################
REM ## CONFIG
REM ###################################################################

set "VBOX_HOME=C:\Program Files\Oracle\VirtualBox"
set "VM_HOME=D:\tools\vms"
set "VM_NAME=vm-alpine"
set "VM_FILE=%VM_HOME%\%VM_NAME%.vdi"
set "VM_INSTALL_ISO=D:\tools\isos\alpine-virt-3.6.2-x86_64.iso"

REM ###################################################################
REM ## END CONFIG
REM ###################################################################

"%VBOX_HOME%\VBoxManage" createhd --filename "%VM_FILE%" --size 1024

"%VBOX_HOME%\VBoxManage" createvm --name "%VM_NAME%" --ostype Linux26_64 --register

"%VBOX_HOME%\VBoxManage" modifyvm "%VM_NAME%" --memory 1024 --cpus 1 --acpi on --pae off --hwvirtex on --nestedpaging on --rtcuseutc on --vram 16 --audio none --accelerate3d off --accelerate2dvideo off --usb on

"%VBOX_HOME%\VBoxManage" modifyvm "%VM_NAME%" --boot1 dvd --boot2 disk --boot3 none --boot4 none

"%VBOX_HOME%\VBoxManage" storagectl "%VM_NAME%" --name "IDE" --add ide

"%VBOX_HOME%\VBoxManage" storagectl "%VM_NAME%" --name "SATA" --add sata

"%VBOX_HOME%\VBoxManage" storageattach "%VM_NAME%" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "%VM_FILE%"

"%VBOX_HOME%\VBoxManage" storageattach "%VM_NAME%" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "%VM_INSTALL_ISO%"

"%VBOX_HOME%\VBoxManage" modifyvm "%VM_NAME%" --natpf1 "guestssh,tcp,,2222,,22"

"%VBOX_HOME%\VBoxManage" startvm "%VM_NAME%"
