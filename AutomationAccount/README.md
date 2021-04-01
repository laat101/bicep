
# Automation Account module deployment with Bicep

I like to use my own runbooks inside Automation Accounts to do all kind of tasks in my Azure environments and in the most cases I am using multiple Az PowerShell modules to do the job. Since we are building all kind of Microsoft related automation stuff (On behalf of my and Leon’s company [CloudAssist](https://www.cloudassist.nl)) we want to deploy Automation Accounts with bicep. And when we deploy Automation Accounts we always want to using the latest module versions.

## The script

This PowerShell script checks your input modules in the PowerShell Gallery, uses the dependency information and deals whit possible dependencies in the outputted bicep file. This script does not providing you a total solution, but helps you to build your own bicep files. Please take the script and modify it so it works for you. Also please take a look at the limitations.

## The limitations

I am not dealing with things like checking minimum, maximum and required dependencies. I am also not checking more then one level of dependencies, but if you make sure that your input list is as complete as possible you will be fine most of the time. You can change the script so it’s fits to your needs. Importing modules in a automation account regularly fails, so make sure you deal whit that in your automation solution.

## Blogpost
Some background information and screenshots can be found [on this blogpost](https://www.microsoft365.nl/automation-account-module-deployment-with-bicep)