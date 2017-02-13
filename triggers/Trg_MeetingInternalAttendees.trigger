trigger Trg_MeetingInternalAttendees on Internal_Attendee__c (before insert, before update,before delete) {
    
    try {
        set<Id> setOfInternalAttendees = new set<Id>();
    
     MeetingInternalAttendeesTriggerHandler Handler=new MeetingInternalAttendeesTriggerHandler();
    if(!trigger.isdelete) {
        for(Internal_Attendee__c iterAttendees : Trigger.new){
        if(iterAttendees.Name__c != null && (Trigger.isInsert || (Trigger.isUpdate && Trigger.oldMap.get(iterAttendees.Id).Name__c != iterAttendees.Name__c))){
            setOfInternalAttendees.add(iterAttendees.Name__c);
        } 
    }

    //Get the users
    Map<id, User> users = new Map<id, User>([Select Id, name, firstName, lastName, email, Title, TimeZoneSidKey from User Where id in :setOfInternalAttendees]);

    for(User iterUser: users.values()){
        AsyncCallOutHelper.copyCheckResource(iterUser.Email, iterUser.Name, iterUser.TimeZoneSidKey);
    }
    if((trigger.isbefore&&trigger.isinsert)||(trigger.isbefore&&trigger.isUpdate)) {       
        
        Handler.updateUniqueness(trigger.new,trigger.NewMap,trigger.OldMap,trigger.isUpdate);
        
    }
        if(trigger.isupdate) {
     //    Handler.RemoveMeetingAssociation(trigger.oldMap,trigger.newMap,trigger.new,trigger.isafter);
        }
    }
    
    if(trigger.isbefore&&trigger.isdelete) {
        Handler.PreventDelete(trigger.old);
    }
        
    }
    catch(Exception ex) {
        ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

    }
}