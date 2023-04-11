# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

New-Item -Path .\bento\packer_templates\scripts\ubuntu\cleanup_ubuntu.sh -ItemType SymbolicLink -Value .\scripts\arm.sh -Force
New-Item -Path .\bento\packer_templates\scripts\ubuntu\select-php.sh -ItemType SymbolicLink -Value .\scripts\select-php.sh -Force
New-Item -Path .\bento\packer_templates\http\ubuntu\preseed.cfg -ItemType SymbolicLink -Value .\http\preseed.cfg -Force
New-Item -Path .\bento\packer_templates\pkr-variables.pkr.hcl -ItemType SymbolicLink -Value .\http\pkr-variables.pkr.hcl -Force

$string = @"
  sources = var.sources_enabled
  provisioner "file" {
    source = "`$`{path.root`}/scripts/ubuntu/select-php.sh"
    destination = "/home/vagrant/select-php.sh"
  }
"@
$content = Get-Content -Path .\bento\packer_templates\pkr-builder.pkr.hcl
$newContent = $content.Replace("  sources = var.sources_enabled", $string)
$newContent | Set-Content -Path .\bento\packer_templates\pkr-builder.pkr.hcl
