############################## INSTRUCTIONS ##############################

 ------------------------------------------------ Prerequisites --------------------------------------------------
 - aws account
 - github account
 - machine with terraform

-------------------------------------------------------------------------------------------------------------------

1 STEP:
  - Build EKS Cluster and Jenkins Machine with Terraform from folder IaaC.
      - terraform init
      - terraform plan
      - terraform apply
      - if you want to clean up everything - terrafrom destroy
-------------------------------------------------------------------------------------------------------------------
2 STEP: 
  - Setup Jenkins Pipeline App with browser http://ip-address:8080 (if there is a problem with opening the page check your security group for port 8080 is it open)
      - Install Docker plugin and from security check option -> no validation
      - Create credentials with private key from Jenkins Machine (ssh-keygen)
-------------------------------------------------------------------------------------------------------------------
3 STEP:
  - Setup GitHub :
      - From GitHub -> Settings -> SSH & GPG KEYS -> New SSH key -> Paste public key from Jenkis machine
-------------------------------------------------------------------------------------------------------------------
4 STEP:
  - Setup MultiBranch Pipeline
      - Give name of the project and pick up from Build -> Git
      - use credentials from STEP 2
      - build project

-------------------------------------------------------------------------------------------------------------------
5 STEP:
  - Open browser try to open page https://vaklinov.online

-------------------------------------------------------------------------------------------------------------------
    
