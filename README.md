I AM USING CODE THAT I FOUND ELSEWHERE FOR CREATING THE MESSAGEBOX : https://gist.github.com/SMSAgentSoftware/0c0eee98a673b6ac34f5215ea6841beb 
I STILL HAVE TESTING TO DO BUT I AM MORE CONFIDENT THIS WILL WORK THE WAY I WANT IT TO

# THIS FUNCTION EXISTS ONLY TO CREATE AND DISPLAY THE MESSAGEBOX
# THIS CAN AND SHOULD BE SIMPLIFIED FOR THIS USAGE I WILL DO THAT LATER
    New-WPFMessageBox
# FIRST STEP WILL COPY THE FILES NEEDED TO EXECUTE INTO AN APPDATA DIRECTORY TO BE THEN EXECUTED VIA SCHEDULED TASKS FOR REBOOTS FROM THE REGISTRY RUN KEY
# GET CURRENT TIME TO CALCULATE WHEN TO WAKE PC FROM SUSPEND STATE
# CREATE TASK THAT WILL OPEN NOTEPAD FILE BUT THIS IS MOSTLY DONE TO FORCE THE PC TO WAKE FROM SUSPEND STATE
# CREATE SCHEDULED TASK TO OPEN TEXT FILE AS A MESSAGE USING THAT BASICALLY AS THE EXCUSE TO USE THE SCHEDULED TASK TO WAKE THE PC FROM SUSPEND STATE
# enable auto-hide the taskbar
# message box pop-up on timer to close
# disable auto-hide the taskbar
# put PC to sleep (suspend state)
# scheduled task that was created and set to execute at specified time will then execute and as part of its own process will wake the PC
