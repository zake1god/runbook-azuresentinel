# How This Runbook Works ?

This is a Runbook Workflow to automatically turn on your VM in Azure Sentinel.

## Step 1: Create the Runbook

1. Open the **Azure Portal** and navigate to your **Automation Account**.
2. In the **Process Automation** section, click **Runbooks**.
3. Click **Create a Runbook**.
   - **Name**: AutoStart-VM
   - **Runbook Type**: PowerShell Workflow
   - **Description**: A workflow to auto-start a VM in Azure.
4. Click **Create**.
5. In the editor, paste script from : `workflow-turnon.sh`
6. Click **Save** and then **Publish** the Runbook.

You can create Schedule from Shared Resource
