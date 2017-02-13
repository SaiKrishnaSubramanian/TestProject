trigger Trg_TimeTradeCustomerAttendee on Customer_Attendee__c (before insert,before update,after insert) {
    try {
        TimeTradeCustomerAttendeeTriggerHandler handler=new TimeTradeCustomerAttendeeTriggerHandler();
        if((trigger.isbefore && trigger.isinsert) || (trigger.isbefore && trigger.isUpdate))
            handler.PreventCreation(Trigger.new,trigger.isInsert);
        if(trigger.isbefore&&trigger.isinsert)
            handler.updateRelationDetails(Trigger.new);
        if(trigger.isinsert && trigger.isAfter) {
            handler.updateInvitationDetails(Trigger.new);
        }
    }    
    catch (Exception ex)
    {                      
        //Insert Debug Log object whenever there is an error
        ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

     /*   Debug_Log__c Log=new Debug_Log__c();
        Log.Line_Number__c=ex.getLineNumber();        
        Log.Error_Description__c=ex.getStackTraceString();
        Log.Error_Message__c=ex.getMessage();
        Log.Exception_Type__c=ex.getTypeName();
        insert Log;
         */
    }
}