## Windows 10pro packer template ##

## Varibales for authentication Azure AD ##
variable "client_id" {
  type = string
  default = ""
  description = "Azure Service Principal App ID."
  sensitive   = true
}

variable "client_secret" {
  type = string
  default = ""
  description = "Azure Service Principal App ID."
  sensitive   = true
}

variable "subscription_id" {
  type = string
  default = ""
  description = "Azure Service Principal App ID."
  sensitive   = true
}

variable "tenant_id" {
  type = string
  default = ""
  description = "Azure Tenant ID"
  sensitive = true
}

## Variables for image creation and configuration ##

variable "managed_image_resource_group_name" {
  type = string
  default = ""
  description = "Packer Artifacts Resource Group"
}

variable "managed_image_name" {
  type = string
  default = ""
  description = "Packer image Name"
}

variable "os_type" {
  type = string
  default = ""
  description = "Windows/Linux."
}

variable "image_publisher" {
  type = string
  default = ""
  description = "Windows Image Publisher."
}

variable "image_offer" {
  type = string
  default = ""
  description = "Windows Image Offer."
}

variable "image_sku" {
  type = string
  default = ""
  description = "Windows Image SKU."
}

variable "image_version" {
  type = string
  default = ""
  description = "Windows Image Version."
}

variable "vm_size" {
  type = string
  default = ""
  description = "Windows Image Size."
}

variable "location" {
  type = string
  default = ""
  description = "Windows image Location"
}

## Azure compute gallery defination varibales ##

variable "gallery_name" {
  type = string
  default = ""
  description = "Windows image gallery name"
}

variable "vm_defination_name" {
  type = string
  default = ""
  description = "Windows image image defination name"
}

variable "vm_image_version" {
  type = string
  default = ""
  description = "Windows image version"
}


source "azure-arm" "win10"{
      client_id = var.client_id
      client_secret = var.client_secret
      subscription_id = var.subscription_id
      managed_image_resource_group_name = var.managed_image_resource_group_name
      managed_image_name = var.managed_image_name
  
      os_type = var.os_type
      image_publisher = var.image_publisher
      image_offer = var.image_offer
      image_sku = var.image_sku
      image_version = var.image_version
      
      communicator = "winrm"
      winrm_use_ssl = true
      winrm_insecure = true
      winrm_timeout = "30m"
      winrm_username = "packer"
      async_resourcegroup_delete = true

  
      location = var.location
      vm_size = var.vm_size
      managed_image_storage_account_type = "Standard_LRS"
      
      shared_image_gallery_destination {
        gallery_name = var.gallery_name
        image_name = var.vm_defination_name
        image_version = var.vm_image_version
        replication_regions = ["westeurope"]
        resource_group = var.managed_image_resource_group_name
        storage_account_type = "Standard_LRS"
      }
      azure_tags = {
          application = "ECAD"
          managed_by  = "packer"
          os          = "Windows10Pro"
          platform    = "Windows"
          task        = "Image Depolyment"
        }

}
build {
      #type = "azure-arm"
      source "azure-arm.win10" {}
     
    provisioner "powershell" {
      script = "windows-install-script.ps1"
    } 
    provisioner "powershell" {

      inline = [
        "Add-WindowsFeature Web-Server",
        "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit",
        "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
      ]
    }
  } 
