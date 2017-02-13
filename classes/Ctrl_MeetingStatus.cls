public class Ctrl_MeetingStatus {
    
    public String pageTitle {get; set;}
    public String custName {get; set;}
    public String accountName {get; set;}
    public String apptStatus {get; set;}
    public String apptConfirmation {get; set;}
    public string selectedTimeZone {get; set;}
    public String apptDate {get; set;}
    public String apptTime {get; set;}
    public String apptNotes {get; set;}
    public List<User> internalAttendeeList {get; set;}
    public Id EvntID;
    public List<Contact> contactAttendeeList {get; set;}
    public List<Lead> leadAttendeeList {get; set;}
    public boolean pollerEnable {get;set;}
    public User primaryResource {get; set;}
    public Contact primaryContact {get; set;}
    public String logoURL{get;set;}

    public TTAppointmentServices.appointment appointment {get; set;}
    public Event ttEvent {get; set;}
    public Invitation__c  ttActivity{get; set;}
    private Customer_Attendee__c ttInvitee;
    
    
    public Boolean showErrorSection{get;set;}
    public Boolean showActions {get; set;}
    public Boolean showLifecycleActions{get;set;}
    
    public Boolean hardError{get;set;}
    public Boolean stopReloadPage{get;set;}
    public String quickAction{get;set;}
    public Boolean pageInit{get;set;}
    
    public String errorTitle {get; set;}
    public String errorSubTitle {get; set;}
    public String errorDescription {get; set;}
   
    
    public TTLinkalatorSettings__c TTLinkalatorSettings {get; set;}
    //private String APIUser = '';
    //private String APIPass = '';
    TTAppointmentWS.AppointmentWS myTTAS;
    
    public Ctrl_MeetingStatus(Event objEvent)
    {
        baseInit();
        ttEvent = objEvent;
        init();
    }
    
    public Ctrl_MeetingStatus(ApexPages.StandardController controller)
    {
        //baseInit();
        stopReloadPage = false;
        pollerEnable = true;
        selectedTimeZone='';
        if (controller.getId() != null)
        {
            system.debug('Event 1'+ controller.getId()) ;
            //ttEvent = (Event) controller.getRecord();
            system.debug('Event 2'+ ttEvent) ;
            ttEvent = [SELECT OwnerID, Subject, Description, TimeTrade_Debug_Log__c,Conference_Callin__c ,Conference_Global_Callin__c ,Conference_Secret__c ,Meeting_Status__c, StartDateTime, EndDateTime, WhoId, WhatId, Confirmation_Number__c, Invitation__c, Conference_Number__c, Conference_Link__c, Location, Conference_Password__c,Conference_Provider__c  FROM Event WHERE Id =: controller.getId() LIMIT 1];
            //system.debug('Event 3'+ ttEvent) ;
            EvntID = controller.getId();
        }
        if(ttEvent != null && ttEvent.TimeTrade_Debug_Log__c != null){
            pollerEnable = false;
        }
       // init();
    }


    
    public void baseInit()
    {
        
        TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
        //APIUser = TTLinkalatorSettings.APIUserName__c;
        //APIPass = TTLinkalatorSettings.APIPassword__c;
        myTTAS = new TTAppointmentWS.AppointmentWS();
        if(ttEvent != null && ttEvent.TimeTrade_Debug_Log__c != null){
            pollerEnable = false;
        }
        
        //myTTAS.SetSecurity(APIUser, APIPass);
        //myTTAS.SetEndpoint(TTLinkalatorSettings.WebServiceEndpoint__c + 'AppointmentServices');
        myTTAS.SetEndpoint('callout:TimeTradeAPI' + '/AppointmentServices');
        myTTAS.SetSecurity('{!$Credential.UserName}', '{!$Credential.Password}');
        
        
        pageInit = false;
        
        accountName = 'Additional';
        
        apptConfirmation = ApexPages.currentPage().getParameters().get('ttConfNum');
        //See if there are any quickactions...
        quickAction = ApexPages.currentPage().getParameters().get('quickAction');
    }
    
    public void init()
    {
        
        try
        {
            if (ttEvent != null)
            {
                if (String.isEmpty(ttEvent.Confirmation_Number__c))
                {
                        system.debug('Confff '+ttEvent);
                    //Invalid
                    system.debug('Invalid conf');
                    ttEvent = null; 
                    apptConfirmation = null;
                }
                else
                {
                    system.debug('Confff1 '+ttEvent);
                    //get the TT appointment
                    apptConfirmation = ttEvent.Confirmation_Number__c;
                    TTAppointmentWS.appointmentByConfirmationNumberStatus apptDetails = myTTAS.getAppointmentByConfirmationNumber(ttEvent.Confirmation_Number__c);
                    appointment = apptDetails.appointment;
                }
            }
        }
        catch(Exception ex)
        {
            exceptionHandler(ex);
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

               if(ex.getTypeName()=='System.CalloutException') {
                 if(ex.getMessage().contains('SOAP Fault'))
                 {
                String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                String[] truncatedError1 = truncatedError[1].split('faultcode');
                errorDescription = truncatedError1[0];
                 }
            }
             
        }
        finally
        {
            if (ttEvent == null && appointment != null)
            {
                showErrorSection = true;
                errorTitle = System.Label.Meeting_Status_Meeting_Not_Present_in_Salesforce	;
                hardError = false;
                errorSubTitle = '';
            }
            else if (ttEvent != null && appointment == null && ttEvent.Meeting_Status__c != 'Canceled')
            {
                showErrorSection = true;
                errorTitle = System.Label.Meeting_Status_Meeting_Not_Present_in_TimeTrade;
                hardError = false;
                errorSubTitle = '';
            }
            else if (ttEvent == null && appointment == null)
            {
                showErrorSection = true;
                errorTitle = 'Invalid Appointment';
                hardError = true;
                errorSubTitle = System.Label.Meeting_Status_No_Meeting;
            }
        }
    }
    
    
    public PageReference pageLoad()
    {
        String ApproverLogo = '';
        stopReloadPage = true;
        if(ttEvent != null && ttEvent.TimeTrade_Debug_Log__c != null ){
            pollerEnable = false;
        }
        String timeZoneName =  ApexPages.currentPage().getParameters().get('timeZone');
        if(timeZoneName!= null){
            selectedTimeZone = timeZoneName;
        }
        System.debug('INSIDE PAGELOAD METHOD---'+selectedTimeZone +'timeeee '+DateTime.Now().format('EEEE, MMMM dd, yyyy h:mm a','America/New_York'));
         TTLinkalatorSettings__c linkSetting = TTLinkalatorSettings__c.getOrgDefaults();
         baseInit();
         init();
         
         //ApproverLogo = linkSetting.Scheduler_Logo__c;             
         List<StaticResource> staticResource;
         Set <String> resourceTypeList = new Set<String> {'JPEG','JPG','PNG','jpeg','jpg','png'};
         
        
        if (showErrorSection == true && hardError == true) return null;        
     
        try
        {   system.debug('LIFE CYCLE--'+ApexPages.currentPage().getParameters().get('lifecycle'));
            string strLifeCycle = ApexPages.currentPage().getParameters().get('lifecycle');
            if (strLifeCycle != null && strLifeCycle.toLowerCase() == 'true') 
            {
                showLifecycleActions = true;
                
            }
            

           
            //Parse the query strings
            
            internalAttendeeList = new List<User>();
            contactAttendeeList = new List<Contact>();
            leadAttendeeList = new List<Lead>();
            List<Id> attendeeIDs = new List<Id>();
            
            if (ttEvent != null)
            {
                showActions = (ttEvent.Meeting_Status__c != 'Canceled'); 
                List<Invitation__c> listOfttActivity = new List<Invitation__c>([SELECT Name, Web_Conference__c, Availability_Start__c, Availability_End__c, Duration__c, Private__c, Notes__c FROM Invitation__c WHERE Id = :ttEvent.Invitation__c]);
                system.debug('activityyyyy '+listOfttActivity);
                if(!listOfttActivity.isEmpty())
                    ttActivity = listOfttActivity[0];
                system.debug('selectedTimeZoneeeee '+selectedTimeZone); 
                system.debug('ttEvent.StartDateTime '+ttEvent.StartDateTime);
                system.debug('ttEvent.StartDateTime '+ttEvent.StartDateTime.format('EEEE, MMMM dd, yyyy h:mm a','America/New_York'));    
                apptDate = ttEvent.StartDateTime.format('EEEE, MMMM dd, yyyy h:mm a',selectedTimeZone);
                system.debug('page loading...'+apptDate);
                apptTime = string.valueOf((ttEvent.EndDateTime.getTime() - ttEvent.StartDateTime.getTime())/60000) + ' minute meeting';
                apptNotes = ttEvent.Description;
                attendeeIDs.add(ttEvent.OwnerId);
                List<User> listOfUsers = new List<User>([SELECT firstName, lastName, email, Title, WebEx_User__c, WebEx_Password__c  from User where Id = :ttEvent.OwnerId LIMIT 1]);
                if(!listOfUsers.isEmpty())
                    primaryResource = listOfUsers[0];
                
                List<Customer_Attendee__c> listOfAssociatedContacts = new List<Customer_Attendee__c>([SELECT Id, Name, Invitation__c, Scheduled__c   FROM Customer_Attendee__c WHERE ConfirmationNumber__c = :ttEvent.Confirmation_Number__c LIMIT 1]);
                //See if an invitee is tagged to this confirmation number
                if (ttEvent.Confirmation_Number__c != '' && !listOfAssociatedContacts.isEmpty())
                {
                    //Ensure if voucher is configured, that the customer ID is valid
                    ttInvitee = listOfAssociatedContacts[0];
                }
                
                //Get the Attendees
                List<EventRelation> eventRels = [SELECT RelationID, IsDeleted, IsInvitee, IsParent, IsWhat, Status FROM EventRelation WHERE EventID=: ttEvent.Id];
                for(EventRelation currentRelation: eventRels)
                {
                    System.debug('Relation:' + currentRelation.RelationId + ' IsDeleted:' + currentRelation.IsDeleted + ' IsInvitee:' + currentRelation.IsInvitee + ' IsParent:' + currentRelation.IsParent + ' IsWhat:' + currentRelation.IsWhat + ' status:' + currentRelation.Status);
                    attendeeIDs.add(currentRelation.RelationID);
                }
                
                internalAttendeeList = [SELECT firstName, lastName, email, Title,SmallPhotoUrl from User where Id in :attendeeIDs];
                contactAttendeeList  = [SELECT FirstName, LastName, AccountId, Email, Title FROM Contact WHERE Id in: attendeeIDs];
                leadAttendeeList = [SELECT FirstName, LastName,  Email, Title FROM Lead WHERE Id in: attendeeIDs];
                pageTitle = ttEvent.Subject;
                System.debug('CONT LIST--'+contactAttendeeList);
                system.debug('LEAD LIST---'+leadAttendeeList);
                
                
                //get Account Name
                /*primaryContact = [SELECT FirstName, LastName, AccountId, Account.Name, Email FROM Contact WHERE Id =: ttEvent.WhoID];
                if (primaryContact != null && primaryContact.AccountId != null)
                {
                    
                    accountName = primaryContact.account.Name;
                }*/
            }
            else if (appointment != null)
            {
                //event not found but appointment found
                pageTitle = 'Manage Meeting';
                apptDate = appointment.appointmentStartDate.format('EEEE, MMMM dd, yyyy h:mm a',selectedTimeZone);
                system.debug('apptDateeee '+apptDate);
                apptTime = appointment.appointmentDurationMin + ' minute meeting';
                internalAttendeeList = [SELECT firstName, lastName, email, Title from User where EMAIL =: appointment.resourceExternalId];
                apptNotes = appointment.custom2;
            }
            
            if (!pageInit)CheckQuickAction();
            if (ttEvent != null )
            {
                
                apptStatus = ttEvent.Meeting_Status__c;
            }
            else if (appointment != null)
            {
                apptStatus = appointment.lifeCycleState.replace('InProgress','Started');
            }
        }
        catch(Exception ex)
        {
            exceptionHandler(ex);
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

               if(ex.getTypeName()=='System.CalloutException') {
                 if(ex.getMessage().contains('SOAP Fault'))
                 {
                String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                String[] truncatedError1 = truncatedError[1].split('faultcode');
                errorDescription = truncatedError1[0];
                 }
            }
             
        }
        pageInit = true;
        return null;
    }
    
    public void hideError()
    {
        showErrorSection = false;
    }
    
    public void CheckQuickAction()
    {
        if (quickAction == null || quickAction == '') return;
        
        
    }
    
    
    
    public PageReference rescheduleAppointment()
    {
        PageReference pageRef = new PageReference('/apex/ClickToSchedule?Id=' + ttActivity.Id + '&ttRescheduleId=' + ttEvent.Id + (ttInvitee != null ? '&ttCustID=' + ttInvitee.Id : ''));
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference cancelAppointment()
    {
        try
        {
            //Send timeTrade the update if ttEvent is null
            if (ttEvent == null && !Test.isRunningTest())
            {
                TTAppointmentWS.TTStatus cancelstatus = myTTAS.cancelAppointment(apptConfirmation);
            }
            else 
            {
                ttEvent.Meeting_Status__c = 'Canceled';
                update ttEvent;
                apptStatus = 'Canceled';
                showActions = false;
                
            }
        }
        catch(Exception ex)
        {
                exceptionHandler(ex);
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

                if(ex.getTypeName()=='System.CalloutException') {
                 if(ex.getMessage().contains('SOAP Fault'))
                 {
                String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                String[] truncatedError1 = truncatedError[1].split('faultcode');
                errorDescription = truncatedError1[0];
                 }
            }

        }        
        
        PageReference pageRef = new PageReference('/apex/MeetingStatus?Id='+ttEvent.Id);
                pageRef.setRedirect(true);
                return pageRef;
    }
    
   public void showWebConfDetails(){
        ttEvent = [SELECT OwnerID, Subject, Description, TimeTrade_Debug_Log__c, Conference_Callin__c ,Conference_Global_Callin__c ,Conference_Secret__c ,Meeting_Status__c, StartDateTime, EndDateTime, WhoId, WhatId, Confirmation_Number__c, Invitation__c, Conference_Number__c, Conference_Link__c, Location, Conference_Password__c,Conference_Provider__c  FROM Event WHERE Id =: EvntID LIMIT 1];
        if(ttEvent.Conference_Number__c ==  null){
            List<Debug_Log__c> debug = new List<Debug_Log__c>([select Id, Record_Detail__c from Debug_Log__c where Record_Detail__c =: ttEvent.Id]);
            if(!debug.isEmpty() && ttEvent.TimeTrade_Debug_Log__c != null){
                
                pollerEnable = false;
                /*if(ttInvitee != null){
                    List <Customer_Attendee__c> listOfAttendees = new List<Customer_Attendee__c> ([select Scheduled__c, ConfirmationNumber__c from Customer_Attendee__c where Invitation__c =: ttEvent.Invitation__c and Id=: ttInvitee.Id]);
                    for (Customer_Attendee__c custAttendee : listOfAttendees){
                        custAttendee.Scheduled__c =false;
                        custAttendee.ConfirmationNumber__c = '';
                    }
                    if(!listOfAttendees.isEmpty()){
                        update listOfAttendees;
                    }
                }
                
                delete ttEvent;*/
                
            } 
        }    
   }

   public void exceptionHandler(Exception ex){
        showErrorSection = true;
        errorTitle = 'Error Canceling Meeting';
        hardError = true;
        errorSubTitle = 'Line: ' + ex.getLineNumber();
        errorDescription = ex.getMessage();

        //Insert Debug Log object whenever there is an error
     /*   Debug_Log__c Log=new Debug_Log__c();
        Log.Line_Number__c=ex.getLineNumber();
        //Log.Record_Detail__c=ttEvent.Id;
        Log.Error_Description__c=ex.getStackTraceString();
        Log.Exception_Type__c=ex.getTypeName();
        Log.Error_Message__c=ex.getMessage();
        insert Log;*/
   }
}