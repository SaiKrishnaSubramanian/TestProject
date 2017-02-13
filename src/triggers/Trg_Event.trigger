trigger Trg_Event on Event (after insert, before update) {
    Set<id> UserIds = new Set<id>();
    Set<id> meetingInviteIds = new Set<id>();
    Set<id> notificationTemplateIds = new Set<id>();
    
    for (Event evt : Trigger.new) {
        UserIds.add(evt.OwnerId);
        if (evt.Invitation__c != null) meetingInviteIds.add(evt.Invitation__c);
    }
    
    Map<id, User> users = new Map<id, User>([Select Id, name, firstName, lastName, email, Title, WebEx_User__c, WebEx_Password__c, TimeZoneSidKey, Zoom_Id__c from User Where id in :UserIds]);
    
    //Get the meeting Invitations
    Map<id, Invitation__c> meetingInvites = new Map<id, Invitation__c>([SELECT ID, Name, Who_ID__c,Duration__c, Location__c, Template__c, Availability_End__c, Availability_Start__c, Notes__c, Private__c,Schedule_URL__c, Send_Email__c, Web_Conference__c, Web_Conference_Password__c   FROM Invitation__c WHERE id in :meetingInviteIds]);
                    
    
    for (Event evt : Trigger.new) {
        
        try
        {
            if (Trigger.isInsert)
            {
                //Check to make sure this is a TimeTrade event
                if (String.isNotBlank(evt.Conference_Number__c))
                {
                    //Put the Event Relations on the Event
                    UtilClass.createEventRelations(evt);
                }
                
                //Check for web conferencing
                if (String.isNotBlank(evt.Conference_Provider__c))
                {
                    //We need to create a meeting
                    If (evt.Conference_Provider__c.toLowerCase() == 'webex' && String.IsNotBlank(users.get(evt.OwnerId).WebEx_User__c) && String.IsNotBlank(users.get(evt.OwnerId).WebEx_Password__c))
                    {
                        //Create a WebEx
                        WebExHelper.createWebex(evt.Id, evt.Subject, evt.Conference_Secret__c, users.get(evt.OwnerId).WebEx_User__c, users.get(evt.OwnerId).WebEx_Password__c, evt.StartDateTime, Integer.valueOf((evt.EndDateTime.getTime() - evt.StartDateTime.getTime())/60000), users.get(evt.OwnerId).TimeZoneSidKey);
                    }
                    
                    else If (evt.Conference_Provider__c.toLowerCase() == 'zoom' && String.IsNotBlank(users.get(evt.OwnerId).Zoom_Id__c))
                    {
                        //Create a Zoom Meeting
                        ZoomHelper.CreateMeeting(evt.Id, evt.Subject, evt.Conference_Secret__c, users.get(evt.OwnerId).Zoom_Id__c, users.get(evt.OwnerId).TimeZoneSidKey, evt.StartDateTime, Integer.valueOf((evt.EndDateTime.getTime() - evt.StartDateTime.getTime())/60000));
                    }
                    
                    
                }
            }
            
            if (Trigger.isUpdate)
            {
                // Access the "old" record by its ID in Trigger.oldMap
                Event oldEvt = Trigger.oldMap.get(evt.Id);
                system.debug('INSIDE UPDATE FOR RECORD--'+oldEvt.Confirmation_Number__c);
                
                //Check for updates to dates/times when using a Web Conference
                if (
                    String.isNotBlank(oldEvt.Conference_Number__c) && String.isNotBlank(evt.Conference_Number__c) &&
                    String.isNotBlank(oldEvt.Conference_Provider__c) && String.isNotBlank(evt.Conference_Provider__c) && 
                    (oldEvt.Conference_Provider__c == evt.Conference_Provider__c) && 
                    (oldEvt.StartDateTime != evt.StartDateTime ||
                     oldEvt.EndDateTime != evt.EndDateTime)
                )
                {
                    //update the web conference
                    If (evt.Conference_Provider__c.toLowerCase() == 'webex' && String.IsNotBlank(users.get(evt.OwnerId).WebEx_User__c) && String.IsNotBlank(users.get(evt.OwnerId).WebEx_Password__c))
                    {
                        //Update a WebEx
                        
                        WebExHelper.updateWebex(evt.Id,users.get(evt.OwnerId).WebEx_User__c, users.get(evt.OwnerId).WebEx_Password__c, evt.StartDateTime, evt.Conference_Number__c, Integer.valueOf((evt.EndDateTime.getTime() - evt.StartDateTime.getTime())/60000), users.get(evt.OwnerId).TimeZoneSidKey);
                    }
                    
                    else If (evt.Conference_Provider__c.toLowerCase() == 'zoom' && String.IsNotBlank(users.get(evt.OwnerId).Zoom_Id__c))
                    {
                        //Update a Zoom Meeting
                        ZoomHelper.UpdateMeeting(evt.Id,users.get(evt.OwnerId).Zoom_Id__c, evt.StartDateTime, evt.Conference_Number__c, Integer.valueOf((evt.EndDateTime.getTime() - evt.StartDateTime.getTime())/60000));
                    }
                    
                    
                }
                
                //Check for changing a web conference provider
                if (oldEvt.Conference_Provider__c != evt.Conference_Provider__c)
                {
                    //Get owner
                    User primaryResource = users.get(evt.OwnerId);
                    
                    //See if an old conference needs to be canceled
                    if (String.isNotBlank(oldEvt.Conference_Provider__c))
                    {
                        //run a check to cancel the web conference
                        //We need to create a meeting
                        If (oldEvt.Conference_Provider__c.toLowerCase() == 'webex' && String.IsNotBlank(users.get(evt.OwnerId).WebEx_User__c) && String.IsNotBlank(users.get(evt.OwnerId).WebEx_Password__c))
                        {
                            //Cancel the WebEx
                            WebExHelper.CancelWebex(evt.Id,evt.Conference_Number__c, primaryResource.WebEx_User__c, primaryResource.WebEx_Password__c);
                        }
                        
                        else If (oldEvt.Conference_Provider__c.toLowerCase() == 'zoom' && String.IsNotBlank(users.get(evt.OwnerId).Zoom_Id__c))
                        {
                            //Cancel a Zoom Meeting
                            ZoomHelper.CancelMeeting(evt.Id,primaryResource.Zoom_ID__c, evt.Conference_Number__c);
                        }
                    }
                    
                    //See if a new conference needs to be added
                    if (String.isNotBlank(evt.Conference_Provider__c))
                    {
                        //We need to create a meeting
                        If (evt.Conference_Provider__c.toLowerCase() == 'webex' && String.IsNotBlank(users.get(evt.OwnerId).WebEx_User__c) && String.IsNotBlank(users.get(evt.OwnerId).WebEx_Password__c))
                        {
                            //Create a WebEx
                            WebExHelper.createWebex(evt.Id, evt.Subject, evt.Conference_Secret__c, users.get(evt.OwnerId).WebEx_User__c, users.get(evt.OwnerId).WebEx_Password__c, evt.StartDateTime, Integer.valueOf((evt.EndDateTime.getTime() - evt.StartDateTime.getTime())/60000), users.get(evt.OwnerId).TimeZoneSidKey);
                        }
                        else If (evt.Conference_Provider__c.toLowerCase() == 'zoom' && String.IsNotBlank(users.get(evt.OwnerId).Zoom_Id__c))
                        {
                            //Create a Zoom Meeting
                            ZoomHelper.CreateMeeting(evt.Id, evt.Subject, evt.Conference_Secret__c, users.get(evt.OwnerId).Zoom_Id__c, users.get(evt.OwnerId).TimeZoneSidKey, evt.StartDateTime, Integer.valueOf((evt.EndDateTime.getTime() - evt.StartDateTime.getTime())/60000));
                        }
                    }
                    else
                    {
                        //Clear the fields
                        evt.Conference_Number__c = '';
                        evt.Conference_Link__c = '';
                        evt.Conference_Secret__c = '';
                        evt.Conference_Callin__c = '';
                        evt.Conference_Global_Callin__c = '';
                    }
                }
                
                //Check for a timetrade meeting
                if (!String.isBlank(evt.Confirmation_Number__c) && evt.Invitation__c != null)
                {
                    //TimeTrade meeting
                    Invitation__c meetingInvite = meetingInvites.get(evt.Invitation__c);
                    
                    //Get the Notification Template
                    //*****NEED TO REPLACE TO SUPPORT BULK OPERATIONS
                    Invitation_Template__c ttNotifTemplate;
                    if (meetingInvite.Template__c != null) ttNotifTemplate = [select id, Name, Send_Confirmation_Email__c, Confirmation_Template_Unique_Name__c, Send_Modification_Email__c, Modification_Template_Unique_Name__c, Send_Reminder_Email__c, Reminder_Template_Unique_Name__c, Send_Completion_Email__c, Completion_Template_Unique_Name__c, Send_NoShow_Email__c, NoShow_Template_Unique_Name__c, Send_Cancelation_Email__c, Cancel_Template_Unique_Name__c, Outlook_Invite__c from Invitation_Template__c where id = : meetingInvite.Template__c];
                    
                    //Get owner
                    User primaryResource = users.get(evt.OwnerId);
                    
                    if (string.valueof(oldEvt.Meeting_Status__c) != string.valueof(evt.Meeting_Status__c))
                    {
                        //Status Changed
                        system.debug('status updated...');
                        
                        //Find the status
                        if (evt.Meeting_Status__c != 'Canceled')
                        {
                            //Check for email notifications
                            if (evt.Meeting_Status__c == 'Completed' && ttNotifTemplate != null && ttNotifTemplate.Send_Completion_Email__c) evt.Trigger_Completion_Email__c = true;
                            else if (evt.Meeting_Status__c == 'NoShow' && ttNotifTemplate != null && ttNotifTemplate.Send_NoShow_Email__c) evt.Trigger_NoShow_Email__c = true;
                            
                            //Update the lifecycle in TT
                            system.debug('about to make callout...');
                            AsyncCallOutHelper.futureSetStatusLifecycle(evt.Confirmation_Number__c, evt.Meeting_Status__c.replace('Started', 'InProgress'));
                            system.debug('finished callout...');
                        }
                        else if (evt.Meeting_Status__c == 'Canceled')
                        {
                            system.debug('canceling meeting...');
                            //Cancel the meeting in TimeTrade
                            AsyncCallOutHelper.futureCancelMeeting(evt.Confirmation_Number__c);
                            
                            //If canceling... cancel web conference
                            if (!String.isBlank(evt.Conference_Number__c) && !String.isBlank(evt.Conference_Provider__c))
                            {
                                //We need to create a meeting
                                If (evt.Conference_Provider__c.toLowerCase() == 'webex' && String.IsNotBlank(users.get(evt.OwnerId).WebEx_User__c) && String.IsNotBlank(users.get(evt.OwnerId).WebEx_Password__c))
                                {
                                    //Cancel the WebEx
                                    WebExHelper.CancelWebex(evt.Id,evt.Conference_Number__c, primaryResource.WebEx_User__c, primaryResource.WebEx_Password__c);
                                }
                                
                                else If (evt.Conference_Provider__c.toLowerCase() == 'zoom' && String.IsNotBlank(users.get(evt.OwnerId).Zoom_Id__c))
                                {
                                    //Cancel a Zoom Meeting
                                    ZoomHelper.CancelMeeting(evt.Id,primaryResource.Zoom_ID__c, evt.Conference_Number__c);
                                }
                                
                                
                                evt.Conference_Provider__c = null;
                                evt.Conference_Number__c = '';
                                evt.Conference_Link__c = '';
                                evt.Conference_Secret__c = '';
                                evt.Conference_Callin__c = '';
                                evt.Conference_Global_Callin__c = '';
                            }
                            
                            //Set email flag if meeting calls for it
                            if (ttNotifTemplate != null && ttNotifTemplate.Send_Cancelation_Email__c) evt.Trigger_Cancelation_Email__c = true;
                            system.debug('finished canceling meeting...');
                        }
                    }
                    
                    system.debug('checking for modifications...');
                    //Check for modifications
                    if (!String.isBlank(evt.Confirmation_Number__c) && 
                        (
                            oldEvt.StartDateTime != evt.StartDateTime ||
                            oldEvt.EndDateTime != evt.EndDateTime ||
                            (oldEvt.Conference_Provider__c != evt.Conference_Provider__c && String.isBlank(evt.Conference_Provider__c))
                        ) && (ttNotifTemplate != null && ttNotifTemplate.Send_Modification_Email__c)
                       )
                    {
                        evt.Trigger_Modification_Email__c = true;
                    }
                    
                    system.debug('checking for email sending...');
                    
                    //NOW SEND THE EMAILS
                    //Check to see if we need to send any emails
                    if (ttNotifTemplate != null && (evt.Trigger_Confirmation_Email__c || 
                                                    evt.Trigger_Modification_Email__c || 
                                                    evt.Trigger_Reminder_Email__c ||
                                                    evt.Trigger_Completion_Email__c ||
                                                    evt.Trigger_NoShow_Email__c ||
                                                    evt.Trigger_Cancelation_Email__c )
                       )
                    {
                        //We are sending something
                        system.debug('we will send an email...');
                        boolean attachICS = evt.Trigger_Confirmation_Email__c || evt.Trigger_Modification_Email__c || evt.Trigger_Cancelation_Email__c ;
                        boolean calendarInvite =ttNotifTemplate.Outlook_Invite__c;
                        string strOrganizer = primaryResource.FirstName + ' ' + primaryResource.LastName;
                        //Get all the invitees
                        List<EventRelation> invitees = [SELECT RelationID FROM EventRelation WHERE EventID=: evt.Id];
                        //Get the email template
                        system.debug('retreiving the template');
                        EmailTemplate myTemplate;
                        
                        string emailTemplateName = '';
                        if (evt.Trigger_Confirmation_Email__c) emailTemplateName = ttNotifTemplate.Confirmation_Template_Unique_Name__c;
                        else if (evt.Trigger_Modification_Email__c) emailTemplateName = ttNotifTemplate.Modification_Template_Unique_Name__c;
                        else if (evt.Trigger_Reminder_Email__c) emailTemplateName = ttNotifTemplate.Reminder_Template_Unique_Name__c;
                        else if (evt.Trigger_Completion_Email__c) emailTemplateName = ttNotifTemplate.Completion_Template_Unique_Name__c;
                        else if (evt.Trigger_NoShow_Email__c) emailTemplateName = ttNotifTemplate.NoShow_Template_Unique_Name__c;
                        else if (evt.Trigger_Cancelation_Email__c) emailTemplateName = ttNotifTemplate.Cancel_Template_Unique_Name__c;
                        myTemplate = [select id, name, body, subject, htmlvalue from EmailTemplate where developername = : emailTemplateName];
                        
                        //Make sure we found a template
                        if (myTemplate != null)
                        {
                            string htmlMergedBody = EmailTemplateMergeUtil.mergeFields(myTemplate.HtmlValue, evt, primaryResource.TimeZoneSidKey).replace('{!Event.Owner}', strOrganizer);
                            htmlMergedBody = EmailTemplateMergeUtil.mergeFields(htmlMergedBody, meetingInvite, primaryResource.TimeZoneSidKey);
                            
                            string plainMergedBody = EmailTemplateMergeUtil.mergeFields(myTemplate.Body, evt, primaryResource.TimeZoneSidKey).replace('{!Event.Owner}', strOrganizer);
                            plainMergedBody = EmailTemplateMergeUtil.mergeFields(plainMergedBody, meetingInvite, primaryResource.TimeZoneSidKey);
                            
                            string emailSubject = calendarInvite && attachICS ? evt.Subject : myTemplate.Subject;
                            
                            //Create the vInvite
                            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                            attach.filename =  evt.Subject + '.ics';
                            attach.ContentType = calendarInvite ? 'text/calendar' : 'text/plain';
                            attach.inline = calendarInvite ? true : false;
                            attach.body = EmailTemplateMergeUtil.CreateICS(evt, primaryResource, invitees, plainMergedBody, calendarInvite);
                            
                            //Start adding the mails
                            Messaging.SingleEmailMessage[] mails = new Messaging.SingleEmailMessage[]{};
                                //add the organizer
                                Messaging.SingleEmailMessage organizerMail = EmailTemplateMergeUtil.CreateEmailNotification(primaryResource.Id, emailSubject, htmlMergedBody);
                            if (organizerMail != null) 
                            {
                                if (attachICS) organizerMail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
                                mails.add(organizerMail);
                            }
                            
                            //get the other invitees
                            for(EventRelation currentRel : invitees)
                            {
                                system.debug('currentRellllll '+currentRel.RelationId);
                                Messaging.SingleEmailMessage mail = EmailTemplateMergeUtil.CreateEmailNotification(currentRel.RelationId, emailSubject, htmlMergedBody);
                                if (mail != null)
                                {
                                    //only put in ics if not reminder
                                    if (attachICS) mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
                                    mails.add(mail);
                                }
                            }
                            
                            system.debug('about to send the email');
                            system.debug('mail size: ' + mails.size());
                            if (mails != null && mails.size()> 0) Messaging.sendEmail(mails);
                        }
                        //Reset the flag
                        evt.Trigger_Confirmation_Email__c  = false;
                        evt.Trigger_Modification_Email__c = false;
                        evt.Trigger_Reminder_Email__c = false;
                        evt.Trigger_Completion_Email__c = false;
                        evt.Trigger_NoShow_Email__c = false;
                        evt.Trigger_Cancelation_Email__c = false;
                    }
                    system.debug('finished email sending...');
                }
            }
        }
        catch(Exception ex)
        {
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

            system.debug('Exception thrown: ' + ex.getMessage());
        }
    }
}