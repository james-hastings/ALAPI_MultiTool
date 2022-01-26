# ALAPI_MultiTool

[![Git](https://app.soluble.cloud/api/v1/public/badges/5824444b-1d43-4433-9e70-86a35b5a3976.svg?orgId=367099919619)](https://app.soluble.cloud/repos/details/github.com/james-hastings/alapi_multitool?orgId=367099919619)  
Bash multitool to leverage Alert Logic Cloud Insight API


I’ve made a bash script multi-tool that uses our APIs to help you find various types of information.  If you have an email/s you use for CID2 it should work with the tool – if you don’t, then sorry, this won’t work for you ☹.  However, if you experience issues, I can assist.

 

What is it:

A bash script (run in OS X or Linux terminal) that does the following:

Find user account by email – tells you the associated CID, Account Name, and what DCs the email works with
Is this email already used in our systems?
What account is this a part of in multi-account setup scenarios?
 

Find Account by CID – returns name as well as which DC the account lives in
Where does this user account actually live?
 

Pull CI usage by CID – enter a CID and specify a month/year to generate a usage Excel spreadsheet
My AE has a CI account in parent child view, and they need some usage figures?
I think we can upsell this account, but how many instances do they have?
 

Content Search – Search for scan signatures by keyword (Covers both TM Scan and CI Scan content)
Do we have scan content for X?
Good for quick on-call queries of scan content based on real-time call discoveries
Need that info in a document – no problem!
 

How to use:

You need to have cURL and jq installed - the 1.1 version checks and prompts to install if your are using Ubuntu, OS X , or Amazon Linux

Install example for Debian: "sudo apt-get install jq" "sudo apt-get install curl"

Download to your Mac (OS X) or Linux Machine, you can use a VM if you’re on Windows, if you have Windows 10 you can actually install Ubuntu Linux Command Line directly into the OS.

The file is attached, but you can also use “wget https://s3.amazonaws.com/james-hastings-alertlogic-download/ALAPI_MultiTool_1.0.sh“

Via command line, navigate to the directory that you downloaded the tool in, then type “chmod +x ALAPI_MultiTool.sh” – this makes the file executable.

To run the script, type “./ALAPI_MultiTool.sh”

You will need to enter your CID2 email address and hit enter/return, then you enter your password and hit return/enter.
There is validation on this – so unless you get a “Credentials Invalid” message everything is good.

Type the number to the corresponding function and hit enter/return…. So on and so forth.

Any output (CI Usage & exported content searches) will appear in the same folder/directory that you have the script stored.
 

PS:  If you are going to use this a lot, you can store your email address in the tool so you don’t have to type it so much.  To do this, just open up the script in an editor and use the fields provided.  Be aware, anything with a “#” doesn’t execute.  So you’d remove the “#” from the “username=” field, and enter yours.  Make sure to add “#” to the prompts to enter a username.

