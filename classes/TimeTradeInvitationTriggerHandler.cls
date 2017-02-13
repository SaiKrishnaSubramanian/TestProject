public with sharing class TimeTradeInvitationTriggerHandler{

    List<Customer_Attendee__c> newInvitees;
    Set<id> meetingIds;
    Messaging.SingleEmailMessage[] mails;
    Map<id, Invitation_Template__c> notificationTemplates;
    Map<String, EmailTemplate> emailTemplates;
     Map<id, User> users;

    public void initialise(List<Invitation__c> newList){
        //Check for WebEx creds on current User
        User currentUser = [select Id, WebEx_User__c, WebEx_Password__c,Zoom_ID__c  from User where Id=: userinfo.getUserId()];

        newInvitees = new List<Customer_Attendee__c>();
        meetingIds = new Set<id>();
        mails = new Messaging.SingleEmailMessage[]{};
        emailTemplates = new Map<String, EmailTemplate>();
        
        Set<id> templateIds = new Set<id>();
        Set<id> UserIds = new Set<id>();
        Set<string> emailTemplateNames = new Set<string>();
        
        for (Invitation__c mInvite : newList){
        system.debug('hereeeeee ');
                //mInvite.criteria__c = 'Ad-Hoc Meeting';
                if (mInvite.Template__c != null) 
                    templateIds.add(mInvite.Template__c);
                if (mInvite.Id != null) 
                    meetingIds.add(mInvite.Id);
                UserIds.add(mInvite.OwnerId);

                if(mInvite.Web_Conference__c != null && mInvite.Web_Conference__c.toLowerCase() == 'webex' && (currentUser.WebEx_User__c == null || currentUser.WebEx_Password__c == null)){
                    mInvite.addError(System.Label.Meeting_Invitation_No_Webex_Credentials_For_User);
                }
                if(mInvite.Web_Conference__c != null && mInvite.Web_Conference__c.toLowerCase() == 'zoom' && currentUser.Zoom_ID__c == null ){
                       
                    mInvite.addError(System.Label.Meeting_Invitation_No_Zoom_Credentials_for_User);
                }
        }
        notificationTemplates = new Map<id, Invitation_Template__c>([Select Name, Invitation_Template__c from Invitation_Template__c Where Id in :templateIds]); 
        
        //now get the email templates
        for(Id key: notificationTemplates.keySet())
            emailTemplateNames.add(notificationTemplates.get(key).Invitation_Template__c);
        
        for(EmailTemplate objCS : [Select developername, Id, name, body, subject, htmlvalue from EmailTemplate Where developername in :emailTemplateNames])
            emailTemplates.put(objCS.developername, objCS);
        
        //Get the users
        users = new Map<id, User>([Select Id, firstName, lastName, email, Title, WebEx_User__c, WebEx_Password__c, TimeZoneSidKey from User Where id in :UserIds]);
      }
      
    public void sendNotifications(Boolean isInsert,List<Invitation__c> newList,Map<Id,Invitation__c> oldMap){
         
         if (isInsert){
            String objecType ='';
            Map<String,ID> MapOfRTIDToRTName=new Map<String,ID>();
            Map<Id,Id> mapOfInviteToWhoId = new Map<Id,Id>();
            Map<Id,Contact> mapOfInviteToCon = new Map<Id,Contact>();
            Map<ID,String> MapofMeetingInvToObjType=new Map<ID,String>();
            Map<Id,Lead> mapOfInviteToLead = new Map<Id,Lead>();
            Set<Id> ContactWhoIds=new Set<Id>();
            Set<Id> LeadWhoIds=new Set<Id>();
                TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
             List<Meeting__c> ListOfMeetings = new List<Meeting__c>([select Id, Invitation__c from Meeting__c where Invitation__c in: newList]);    
            for(Invitation__c mInvite : newList){
                objecType=getObjectAPIName(mInvite.Who_ID__c);
                MapofMeetingInvToObjType.put(mInvite.Id,objecType);
               /* if(mInvite.Who_ID__c.startswith('003')){
                    objecType = 'Contact';
                    mapOfInviteToWhoId.put(mInvite.Id,mInvite.Who_ID__c);
                }
                else if(mInvite.Who_ID__c.startswith('00Q')){
                    objecType = 'Lead';
                    mapOfInviteToWhoId.put(mInvite.Id,mInvite.Who_ID__c);
                }*/
            }
            String sObj = '';
            if(String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = 'Customer_Attendee__c';
            else if(!String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = TTLinkalatorSettings.Namespace_Prefix__c + 'Customer_Attendee__c';
             for(RecordType RT:[select id,sobjecttype,developername  from recordtype where sobjecttype=:sObj]) {
                 MapOfRTIDToRTName.put(RT.developername,RT.id);
             }
             for(Invitation__c mInvite : newList) {
                 if(MapofMeetingInvToObjType.get(mInvite.Id)=='Contact')
                     ContactWhoIds.add(mInvite.Who_ID__c);
                 else if(MapofMeetingInvToObjType.get(mInvite.Id)=='Lead')
                     LeadWhoIds.add(mInvite.Who_ID__c);
             }
            
                for(Contact iterCon: [select Id,firstName, LastName, email, phone from Contact where Id in:ContactWhoIds ]){
                    mapOfInviteToCon.put(iterCon.Id,iterCon);
                }
            
            
                for(Lead iterLead: [select Id,firstName, LastName, email, phone from Lead where Id in: LeadWhoIds ]){
                    mapOfInviteToLead.put(iterLead.Id,iterLead);
                }
            
            if(newList.size()==1){
                system.debug('NewLissst '+newList);
                Invitation__c mInvite = newList[0];
                Customer_Attendee__c newInvite;
                if(mInvite.Who_ID__c != null)
                {
                    newInvite = new Customer_Attendee__c();
                    if(MapofMeetingInvToObjType.get(mInvite.Id)=='Contact'){
                        newInvite.Contact__c = mInvite.Who_ID__c;
                        newInvite.Type__c = 'Contact'; 
                        //newInvite.Attendee_s_Name__c = mapOfInviteToCon.get(mInvite.Who_ID__c).firstName +' '+ mapOfInviteToCon.get(mInvite.Who_ID__c).LastName;
                        newInvite.Attendee_First_Name__c = mapOfInviteToCon.get(mInvite.Who_ID__c).firstName;
                        newInvite.Attendee_Last_Name__c = mapOfInviteToCon.get(mInvite.Who_ID__c).LastName;
                        newInvite.Attendee_Phone__c = mapOfInviteToCon.get(mInvite.Who_ID__c).Phone;
                        newInvite.Attendee_Email__c = mapOfInviteToCon.get(mInvite.Who_ID__c).Email;
                        newInvite.RecordTypeId=MapOfRTIDToRTName.get('Contact_Related');
                        if(!ListOfMeetings.isEmpty()){
                                newInvite.Meeting__c = ListOfMeetings[0].Id;
                            }
                    }
                    if(MapofMeetingInvToObjType.get(mInvite.Id)=='Lead'){
                        newInvite.Lead__c = mInvite.Who_ID__c;
                        //newInvite.Attendee_s_Name__c = mapOfInviteToLead.get(mInvite.Who_ID__c).firstName +' '+ mapOfInviteToLead.get(mInvite.Who_ID__c).LastName;
                        newInvite.Type__c = 'Lead';
                        newInvite.Attendee_First_Name__c = mapOfInviteToLead.get(mInvite.Who_ID__c).firstName;
                        newInvite.Attendee_Last_Name__c = mapOfInviteToLead.get(mInvite.Who_ID__c).LastName;
                        newInvite.Attendee_Phone__c = mapOfInviteToLead.get(mInvite.Who_ID__c).Phone;
                        newInvite.Attendee_Email__c = mapOfInviteToLead.get(mInvite.Who_ID__c).Email;
                        newInvite.RecordTypeId=MapOfRTIDToRTName.get('Lead_Related');
                        if(!ListOfMeetings.isEmpty()){
                                newInvite.Meeting__c = ListOfMeetings[0].Id;
                            }
                    }
                    newInvite.Who_ID__c = mInvite.Who_ID__c;
                    newInvite.Invitation__c = mInvite.Id;
                    //if (mInvite.Related_Case__c != null) 
                        //newInvite.Related_Case__c = mInvite.Related_Case__c;
                    insert newInvite;   
                }
                //See if we want to send an email
                if (mInvite.Send_Email__c && mInvite.Template__c != null && !String.isBlank(notificationTemplates.get(mInvite.Template__c).Invitation_Template__c))
                {
                    
                    newInvite = [Select Id, Name, Contact__c, Invitation_Name__c, Invitation__c, Owner_Name__c, Scheduled__c, Schedule_URL__c from Customer_Attendee__c Where ID = : newInvite.Id ];
                    //We need to send the email
                    String emailTemplateName = notificationTemplates.get(mInvite.Template__c).Invitation_Template__c;
                    EmailTemplate myTemplate = emailTemplates.get(emailTemplateName);
                    
                    Messaging.SingleEmailMessage mailtoSend = sendEmailToInvitee(newInvite,myTemplate,mInvite,true);
                    mails.add(mailtoSend);
                    
                }
            }
            /*List<Meeting_Relations__c> listOfMeetingRelations = new List<Meeting_Relations__c>();
            for(Invitation__c iterLink : newList){
                Meeting_Relations__c meetingRelation = new Meeting_Relations__c();
                meetingRelation.Invitation__c = iterLink.Id;
                if(iterLink.Related_Object__c == 'Contact'){
                    meetingRelation.Related_Contact__c = iterLink.Who_ID__c;
                }
                else if(iterLink.Related_Object__c == 'Lead'){
                    meetingRelation.Related_Lead__c = iterLink.Who_ID__c;
                }
                listOfMeetingRelations.add(meetingRelation);
            }
            
            if(!listOfMeetingRelations.isEmpty()){
                insert listOfMeetingRelations;
            }*/
        }
        
        if(!isInsert){ //If update
            //Get the invitees
            Map<id, Customer_Attendee__c> existingInvitees = new Map<id, Customer_Attendee__c>([Select Id, Lead__c,Contact__c, Invitation_Name__c, Invitation__c, Owner_Name__c, Scheduled__c, Schedule_URL__c, ConfirmationNumber__c ,Attendee_Name__c,Attendee_First_Name__c,Attendee_Last_Name__c from Customer_Attendee__c Where Invitation__c in :meetingIds]);
            
            for (Invitation__c mInvite : newList){
                Invitation__c oldInvite = oldMap.get(mInvite.Id);
                //See if the email flag has been raised
                if (!oldInvite.Send_Email__c && mInvite.Send_Email__c && mInvite.Template__c != null && !String.isBlank(notificationTemplates.get(mInvite.Template__c).Invitation_Template__c)) 
                {   
                    //We need to send the email
                    String emailTemplateName =notificationTemplates.get(mInvite.Template__c).Invitation_Template__c;
                    EmailTemplate myTemplate = emailTemplates.get(emailTemplateName);
                    
                    //loop through the invitees
                    for (Id key: existingInvitees.keySet())
                    {
                        Customer_Attendee__c currentInvitee = existingInvitees.get(key);
                        if (currentInvitee.Invitation__c == mInvite.Id)
                        {
                            Messaging.SingleEmailMessage mailtoSend;
                            
                            //We will send an email with this invitee
                            mailtoSend = sendEmailToInvitee(currentInvitee,myTemplate,mInvite,false);
                            mails.add(mailtoSend);
                            
                            
                        }
                    }
                    //Reset the flag
                    mInvite.Send_Email__c = false;
                }
            }
        }
        
        if (mails != null && mails.size()> 0 && !Test.isRunningTest()){
            system.debug('Mailsss '+mails);
            Messaging.sendEmail(mails);
        }
    }
    
    private Messaging.SingleEmailMessage sendEmailToInvitee(Customer_Attendee__c invitee,EmailTemplate currentTemplate,Invitation__c mInvite,Boolean isPrimary){
        system.debug('mInviteeeee '+mInvite);
        Id contactId;
        if(invitee.Contact__c != null){
            contactId = invitee.Contact__c;
        }
        else if(invitee.Lead__c != null){
            contactId = invitee.Lead__c;
        }
        system.debug('mInviteeeee '+contactId);
            
        string htmlMergedBody = EmailTemplateMergeUtil.mergeFields(currentTemplate.HtmlValue, invitee, users.get(mInvite.OwnerId).TimeZoneSidKey);
        htmlMergedBody = EmailTemplateMergeUtil.mergeFields(htmlMergedBody, mInvite, users.get(mInvite.OwnerId).TimeZoneSidKey);
        string emailSubject = EmailTemplateMergeUtil.mergeFields(currentTemplate.Subject, invitee, users.get(mInvite.OwnerId).TimeZoneSidKey);
        Messaging.SingleEmailMessage currentMail = EmailTemplateMergeUtil.CreateEmailNotification(contactId, emailSubject, htmlMergedBody);
        return currentMail;
    }
   
    public void CreateInternalAttendees(List<Invitation__c> TriggerNew) {
            system.debug('INSIDE METHOD---'+TriggerNew);
        List<Internal_Attendee__c> ListOfInternalAttendees=new List<Internal_Attendee__c>();
        List<Meeting__c> ListOfMeetings = new List<Meeting__c>([select Id, Invitation__c from Meeting__c where Invitation__c in: TriggerNew]);
        for(Invitation__c currentMeeting:TriggerNew) {
          
            Internal_Attendee__c NewAttendee=new Internal_Attendee__c();
            //NewAttendee.Name=currentMeeting.Name+'-'+userinfo.getName(); 
            NewAttendee.Name__c=userinfo.getUserId();
            NewAttendee.Invitation__c=currentMeeting.ID;
            NewAttendee.Organizer__c=true;
            if(!ListOfMeetings.isEmpty()){
                NewAttendee.Meeting__c = ListOfMeetings[0].Id;
            }
            
            ListOfInternalAttendees.add(NewAttendee);
        }
        if(ListOfInternalAttendees.size()>0)
            insert ListOfInternalAttendees;
    }

    public void createTimeTradeMeeting(List<Invitation__c> TriggerNew){
        List<Meeting__c> ListOfMeeting = new List<Meeting__c>();
        for(Invitation__c currentMeeting:TriggerNew) {
            Meeting__c newMeeting = new Meeting__c();
            newMeeting.Invitation__c = currentMeeting.Id;
            ListOfMeeting.add(newMeeting);
        }    
        if(ListOfMeeting.size()>0)
            insert ListOfMeeting;
    }
    public static string getObjectAPIName(String recordId ){
        if(recordId == null)
            return null;
        String objectAPIName = '';
        String keyPrefix = recordId.substring(0,3);
        for( Schema.SObjectType obj : Schema.getGlobalDescribe().Values() ){
            String prefix = obj.getDescribe().getKeyPrefix();
            if(prefix == keyPrefix){
                objectAPIName = obj.getDescribe().getName();
                break;
            }
        }
        return objectAPIName;
    }
}