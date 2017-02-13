public class UtilClass{
    
    public static void createEventRelations(Event evt){
        
        //Insert all the attendees           
        List<EventRelation> attendees = new List<EventRelation>();            
        Set<Id> attendeeIds = new Set<Id>();
        
        for(Internal_Attendee__c attendee:[SELECT ID,Name__c,Organizer__c,Invitation__c,Name__r.Email,Name__r.firstName,Name__r.lastName,Name__r.Title,Name__r.WebEx_User__c,Name__r.WebEx_Password__c,createdDate FROM Internal_Attendee__c WHERE Invitation__c =:evt.Invitation__c]) {
            if(attendee.Organizer__c==false) 
            {
                if (!attendeeIds.contains(attendee.Name__c))attendeeIds.add(attendee.Name__c);
                //attendees.add(new EventRelation(EventID = evt.Id, IsInvitee = true, RelationID = attendee.Name__c, Status = 'Accepted'));
            }
        }
        
        //Need to see if the event relation exists or not
        List<EventRelation> EventRelationList=[SELECT RelationID, IsInvitee,IsParent FROM EventRelation WHERE EventID=: evt.Id AND IsWhat =: false];
        if (EventRelationList.size() > 0)
        {
            List<EventRelation> addedAttendees = EventRelationList;
            for(EventRelation currRel : addedAttendees)
            {
                currRel.IsInvitee = true;
                currRel.Status = 'Accepted';
            }
            update addedAttendees;
        }
        else
        {
            if (!attendeeIds.contains(evt.WhoId))attendeeIds.add(evt.WhoId);
            //attendees.add(new EventRelation(EventID = evt.Id, IsInvitee = true, RelationID = evt.WhoId, Status = 'Accepted'));
        }
        
        //Get the other customer attendees
        List<string> custAttendees = new List<string>();
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        if(evt.Additional_Contacts__c != null && evt.Additional_Contacts__c != ''){
            for(string currentEmail: evt.Additional_Contacts__c.split('[,]{1}[\\s]?'))
            {
                if (Pattern.matches(emailRegex, currentEmail.trim()))
                {
                    custAttendees.add(currentEmail.trim());
                }
            }
        }
        
        //get existing contacts
        List<Contact> attendeeContacts = [select id, email from Contact WHERE email in: custAttendees];
        List<Contact> newContacts = new List<Contact>();
        //Loop through the attendees
        
        
        for (string currentEmail: custAttendees)
        {
            boolean match = false;
            for(Contact Con:attendeeContacts)
            {
                if (Con.email.toLowerCase() == currentemail.toLowerCase())
                {
                    if (!attendeeIds.contains(Con.Id))attendeeIds.add(Con.Id);
                    //attendees.add(new EventRelation(EventID = evt.Id, IsInvitee = true, RelationID = Con.Id, Status = 'Accepted'));
                    match = true;
                    break;
                }
            }
            
            
            if (!match)
            {
                //We need to create the contact
                Contact newContact = new Contact();
                newContact.LastName = currentEmail.split('@')[0];
                //if (accID != null) newContact.AccountId = accID;
                newContact.Email = currentEmail;
                newContacts.add(newContact);
            }
        }
        if (newContacts.size() > 0) insert newContacts;
        
        //one last loop through the newly created contacts, to get the ids into the attendees
        for (Contact currentC: newContacts)
        {
            if (!attendeeIds.contains(currentC.Id))attendeeIds.add(currentC.Id);
            //attendees.add(new EventRelation(EventID = evt.Id, IsInvitee = true, RelationID = currentC.Id, Status = 'Accepted'));
        }
        
        //Add the attendees
        for(ID currentId: attendeeIds)
        {
            attendees.add(new EventRelation(EventID = evt.Id, IsInvitee = true, RelationID = currentId, Status = 'Accepted'));
        }
        
        system.debug('ATTENDEES---'+attendees);
        if (attendees.size() > 0)insert attendees;
    }
    
    public static void copyCheckResource(string userExternalID, string userName, string timeZoneName)
    {
        try
        {
            //first see if the resource is there
            TTConfigurationWS.ConfigurationWS myTTCS = new TTConfigurationWS.ConfigurationWS();
            TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
            myTTCS.SetEndpoint('callout:TimeTradeAPI' + '/ConfigurationServices');
            myTTCS.SetSecurity('{!$Credential.UserName}', '{!$Credential.Password}');
            
            TTConfigurationServices.resource myResource = new TTConfigurationServices.resource();
            if(!Test.isRunningTest()) myResource = myTTCS.getResourceByExternalId(TTLinkalatorSettings.Location_External_ID__c, userExternalID);
            
            if (myResource == null || String.IsBlank(myResource.resourceExternalId))
            {
                //We need to create the resource
                TTConfigurationWS.TTStatus copyStatus;
                if(!Test.isRunningTest()) copyStatus = myTTCS.copyResourceDeep(TTLinkalatorSettings.Location_External_ID__c,TTLinkalatorSettings.Template_Resource_ExternalID__c,TTLinkalatorSettings.Location_External_ID__c,userExternalID);
                
                //get resource again
                if(!Test.isRunningTest()) myResource = myTTCS.getResourceByExternalId(TTLinkalatorSettings.Location_External_ID__c, userExternalID);
                
                //Update name and timeZone
                myResource.resourceName = userName;
                myResource.timezone = timeZoneName;
                TTConfigurationWS.resourceRules newRules = new TTConfigurationWS.resourceRules();
                newRules.applyTimezone = true;
                myResource.resourceRules = newRules;
                
                TTConfigurationWS.TTStatus updateStatus;
                if(!Test.isRunningTest()) updateStatus = myTTCS.updateInsertResource(myResource);
                
            }
        }
        catch(Exception ex)
        {
             ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

            system.debug('Exception on line ' + ex.getLineNumber() + ' : ' + ex.getMessage());
        }
        
    }
      
}