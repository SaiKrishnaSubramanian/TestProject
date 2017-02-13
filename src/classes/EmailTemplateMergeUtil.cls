public class EmailTemplateMergeUtil {
    public static String mergeFields(string input, SObject sObj, string tzID)
    {
        system.debug('Loading Field Names');
        //Map<String,Object> mfields = sObj.getPopulatedFieldsAsMap();
        Map<String,Schema.SObjectField> mfields = sObj.getSObjectType().getDescribe().fields.getMap();
        for (SObjectField field: mfields.values()) {
            // Passed in object has the field
            string fieldName = field.getDescribe().getName();
            //system.debug('Looking at field: ' + fieldName);
            try 
            {
                
                Schema.DisplayType fieldType = field.getDescribe().getType();
                string matchString = '{!' + sObj.getSobjectType().getDescribe().getName() + '.' + fieldName + '}';
                if (sObj.get(fieldName) == null)
                {
                    input = input.replace(matchString, '');
                }
                else if (fieldType == Schema.DisplayType.DATETIME)
                {
                    input = input.replace(matchString, datetime.valueOf(sObj.get(fieldName)).format('EEEE, MMMMM dd, yyyy hh:mm a z', tzID));
                }
                else
                {
                    //system.debug('replacing:' + matchString + ' with ' + String.valueOf(sObj.get(fieldName)));
                    input = input.replace(matchString, String.valueOf(sObj.get(fieldName)));
                }
            } 
            catch (Exception ex) 
            {
                
            }
        }
        return input;
    }
    
    public static Blob CreateICS(Event evt, User evtOwner, List<EventRelation> invitees, string body, boolean invite) {
       String txtInvite = '';
        try {
            list<id> userIds = new list<id>();
            list<id> contactIds = new list<id>();
            list<id> leadIds = new list<id>();
            for(EventRelation currentRelation: invitees)
            {
                ID currentID = currentRelation.RelationID;
                if (currentID.getSobjectType().getDescribe().getName() == 'Contact') contactIds.add(currentID);
                if (currentID.getSobjectType().getDescribe().getName() == 'User') userIds.add(currentID);
                if (currentID.getSobjectType().getDescribe().getName() == 'Lead') leadIds.add(currentID);
            }
            List<Contact> contactAttendees = [SELECT FirstName, LastName, Email FROM Contact WHERE ID IN: contactIDs];
            List<User> userAttendees = [SELECT FirstName, LastName, Email FROM User WHERE ID IN: userIds];
            List<Lead> leadAttendees = new List<Lead>([SELECT FirstName, LastName, Email FROM Lead WHERE ID IN: leadIds]);
            //Get the timeZone
            Timezone tz = Timezone.getTimeZone(evtOwner.TimeZoneSidKey);
            
            txtInvite += 'BEGIN:VCALENDAR\n';
            txtInvite += 'PRODID:-//Force.com Labs//iCalendar Export//EN' + '\n';
            txtInvite += 'VERSION:2.0\n';
            txtInvite += 'CALSCALE:GREGORIAN' + '\n';
            
            if (evt.Meeting_Status__c == 'Canceled')
                txtInvite += 'METHOD:CANCEL' + '\n';
            else if (invite) 
                txtInvite += 'METHOD:REQUEST'+ '\n';
            else 
                txtInvite += 'METHOD:PUBLISH'+ '\n';
    
             //Timezone Offset in ICS
            txtInvite += 'BEGIN:VTIMEZONE' + '\n';
            txtInvite += 'TZID:' + tz.getID() + '\n';
            txtInvite += 'TZURL:http://tzurl.org/zoneinfo-outlook/' + tz.getID() + '\n';
            txtInvite += 'BEGIN:DAYLIGHT' + '\n';
            txtInvite += 'TZOFFSETFROM:' + datetime.newInstance(2000,1,1).format('Z', tz.getID()) + '\n';
            txtInvite += 'TZOFFSETTO:' + datetime.newInstance(2000,7,1).format('Z', tz.getID()) + '\n';
            //txtInvite += 'TZNAME:EDT' + '\n';
            txtInvite += 'DTSTART:19700308T020000' + '\n';
            txtInvite += 'RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU' + '\n';
            txtInvite += 'END:DAYLIGHT' + '\n';
            txtInvite += 'BEGIN:STANDARD' + '\n';
            txtInvite += 'TZOFFSETFROM:' + datetime.newInstance(2000,7,1).format('Z', tz.getID()) + '\n';
            txtInvite += 'TZOFFSETTO:' + datetime.newInstance(2000,1,1).format('Z', tz.getID()) + '\n';
            //txtInvite += 'TZNAME:EST' + '\n';
            txtInvite += 'DTSTART:19701101T020000' + '\n';
            txtInvite += 'RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU' + '\n';
            txtInvite += 'END:STANDARD' + '\n';
            txtInvite += 'END:VTIMEZONE' + '\n';
               
            
            txtInvite += 'BEGIN:VEVENT\n';
            txtInvite += 'CREATED:' + evt.CreatedDate.formatGmt('yyyyMMdd\'T\'HHmmss') + 'Z\n';
            txtInvite += 'LAST-MODIFIED:' + evt.LastModifiedDate.formatGmt('yyyyMMdd\'T\'HHmmss') + 'Z\n';
            //txtInvite += 'DTEND:' + evt.EndDateTime.formatGmt('yyyyMMdd\'T\'HHmmss') + 'Z\n';
            txtInvite += 'DTSTAMP:' + DateTime.now().formatGmt('yyyyMMdd\'T\'HHmmss') + 'Z\n';
            txtInvite += 'DTSTART;TZID="' + tz.getID() + '":' + evt.StartDateTime.format('yyyyMMdd\'T\'HHmmss', tz.getID()) + '\n';
            txtInvite += 'DTEND;TZID="' + tz.getID() + '":' + evt.EndDateTime.format('yyyyMMdd\'T\'HHmmss', tz.getID()) + '\n';
            txtInvite += 'LOCATION:' + (String.isBlank(evt.Location) ? '' : evt.Location) + '\n';
            txtInvite += 'SUMMARY;ENCODING=QUOTED-PRINTABLE:' + evt.Subject + '\n';
            txtInvite += 'DESCRIPTION:' + (invite ? '' : body.replace('\r\n', '\\n')) + '\n';
            txtInvite += 'ORGANIZER;CN="'+ evtOwner.FirstName + ' ' + evtOwner.LastName +'":MAILTO:'+ evtOwner.Email + '\n';
            
            if (invite)
            {
                
                //add the users
                for(User currentUser : userAttendees)
                {
                    txtInvite += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE' + (String.isNotBlank(currentUser.FirstName) ? ';CN=' + currentUser.FirstName + ' ' + currentUser.LastName : '') + ':mailto:' + currentUser.Email + '\n';
                }
                for(Contact currentContact : contactAttendees)
                {
                    txtInvite += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE' + (String.isNotBlank(currentContact.FirstName) ? ';CN=' + currentContact.FirstName + ' ' + currentContact.LastName : '') + ':mailto:' + currentContact.Email + '\n';
                }
                for(Lead currentLead : leadAttendees){
                    txtInvite += 'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE' + (String.isNotBlank(currentLead.FirstName) ? ';CN=' + currentLead.FirstName + ' ' + currentLead.LastName : '') + ':mailto:' + currentLead.Email + '\n';
                }
                txtInvite += 'X-MICROSOFT-DISALLOW-COUNTER:TRUE\n';
                txtInvite += 'TRANSP:OPAQUE' + '\n';
            }
            
            txtInvite += 'UID:' + evt.Id + '\n';
            txtInvite += 'SEQUENCE:1\n';
            
            if (evt.Meeting_Status__c == 'Canceled')
                txtInvite += 'STATUS:CANCELLED' + '\n';
            else
                txtInvite += 'STATUS:CONFIRMED' + '\n';
            
            txtInvite += 'END:VEVENT\n';
            txtInvite += 'END:VCALENDAR';            
        }
        catch (Exception ex) 
            {              
                exceptionHandler(ex);
            }
        

        return Blob.valueOf(txtInvite);
    }
    
    public static Messaging.SingleEmailMessage CreateEmailNotification(ID recipient, string subject, string htmlBody)
    {
        Messaging.SingleEmailMessage mail;
        try {
             
            //system.debug('adding the contact');
            mail = new Messaging.SingleEmailMessage();
            //mail.setTemplateId(myTemplate.Id);
            mail.setTargetObjectId(recipient);
            //mail.saveAsActivity = false;
            if (recipient.getSobjectType().getDescribe().getName() == 'User') mail.saveAsActivity = false;
            
            //mail.setPlainTextBody('');
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
           
        
            
        }
       catch (Exception ex) 
            {              
                exceptionHandler(ex);
            }
        return mail;
    }

    public static void exceptionHandler(Exception ex){
        //Insert Debug Log object whenever there is an error
        Debug_Log__c Log=new Debug_Log__c();
        Log.Line_Number__c=ex.getLineNumber();
        Log.Record_Detail__c=ex.getMessage();
        Log.Error_Description__c=ex.getStackTraceString();
        Log.Exception_Type__c=ex.getTypeName();
        insert Log;
    }
    
    public static void eventWebConferenceDetails(Id evtID, String meetingNumber, String joinURL, String MeetingPassword, String dialInNumber, String additionalNumber){
        //get event and update
        EVENT evt = [SELECT ID, Conference_Number__c,Additional_Contacts__c,Invitation__c,Invitation__r.Template__r.Send_Confirmation_Email__c, Conference_Link__c,WhoId FROM EVENT WHERE ID=:evtID LIMIT 1];
        evt.Conference_Number__c = meetingNumber;
        evt.Conference_Link__c = joinURL;
        evt.Conference_Callin__c = dialInNumber;
        evt.Conference_Global_Callin__c = additionalNumber;
        evt.Conference_Secret__c = MeetingPassword;
        if(evt.Invitation__r.Template__r.Send_Confirmation_Email__c)
            evt.Trigger_Confirmation_Email__c = true;
        System.debug('EVENT IS--'+evt);
        update evt;

    }
}