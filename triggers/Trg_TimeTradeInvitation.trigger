trigger Trg_TimeTradeInvitation on Invitation__c(After insert, Before Update) {      
    TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
    try 
    {
           if(TTLinkalatorSettings.Mute_Triggers__c==false) {
                TimeTradeInvitationTriggerHandler LTHandler = new TimeTradeInvitationTriggerHandler();
               if((Trigger.isInsert&&Trigger.isAfter)||(Trigger.isbefore&&Trigger.isUpdate)) {
                   LTHandler.initialise(Trigger.new);
                   if(Trigger.isInsert&&Trigger.isAfter){
                      LTHandler.createTimeTradeMeeting(Trigger.new);
                      LTHandler.CreateInternalAttendees(Trigger.new);
                    }
                   LTHandler.sendNotifications(Trigger.isInsert,Trigger.new,Trigger.Oldmap);                      
               }          
        }
    }
    catch(Exception ex)
    {
        system.debug('Exception thrown: ' + ex.getMessage());
        //Insert Debug Log object whenever there is an error
        ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
        /*Debug_Log__c Log=new Debug_Log__c();
        Log.Line_Number__c=ex.getLineNumber();               
        Log.Error_Description__c=ex.getStackTraceString();
        Log.Error_Message__c=ex.getMessage();
        Log.Exception_Type__c=ex.getTypeName();
        insert Log;*/
    }
    
    
    
    
}