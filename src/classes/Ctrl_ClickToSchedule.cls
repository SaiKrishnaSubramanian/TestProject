public class Ctrl_ClickToSchedule  {
    public List<DateControl> monthDays{get; set;}
    public List<DateControl> dayTimes{get; set;}
    public TTAppointmentWS.dateTimeSlot[] monthSlots {get; set;}     
    private Date selectedDate = date.today();
    public integer selectedDay {get; set;}
    public long selectedTime {get; set;}
    public DateTime dtselectedTime {get; set;}
    public List<SelectOption> TimeZoneOptions {get; set;}
    public Timezone tz = Timezone.getTimeZone('America/New_York');
    public string strTZ {get; set;}
    public string logoURL {get;set;}
    public string timeZoneName{get;set;}    
    TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
    public Invitation__c  ttActivity{get;set;}
    public Meeting__c  ttMeeting{get;set;}
    public Event  rescheduleEvent {get;set;}   
    public Customer_Attendee__c ttInvitee;
    public Invitation_Template__c ttNotifTemplate {get;set;}   
    TTAppointmentWS.AppointmentWS myTTAS;
    TTClientServices.ClientWS myTTCS;
    TTAppointmentWS.appointmentCriteria apptCriteria;
    public String webExMeetingID {get; set;}
    public String webExURL {get; set;}        
    public Boolean showErrorSection{get;set;}
    public Boolean hardError{get;set;}
    public Boolean showAttendeeSection{get;set;}   
    public Boolean showTimeSection{get;set;}
    public Boolean showClientSection{get;set;}
    public String pageTitle {get; set;}
    public String errorTitle {get; set;}
    public String errorSubTitle {get; set;}
    public String errorDescription {get; set;}
    public List<Internal_Attendee__c> attendeeList {get; set;}
    public String custFirstName {get; set;}
    public String custLastName {get; set;}
    public String custEmail {get; set;}
    public String custPhone {get; set;}
    public String apptNotes {get; set;}
    public String custAttendeeList {get; set;}    
    public String prevMonthClass {get
    {
        if ((ttActivity != null && selectedDate.toStartOfMonth() > ttActivity.Availability_Start__c.addseconds(tz.getOffset(ttActivity.Availability_Start__c)/1000).date()) || 
            (ttActivity == null && selectedDate.toStartofMonth() > Date.today().toStartofMonth())
        ) 
            return 'navigator'; 
        else return 'navigator disabled'; 
    }
                                 }
    public String nextMonthClass {get
    {
          
        if ((ttActivity != null && selectedDate.addMonths(1) <= ttActivity.Availability_End__c.addseconds(tz.getOffset(ttActivity.Availability_End__c)/1000).date()) || 
            (ttActivity == null && selectedDate <= Date.today().addMonths(6))
            ) 
            return 'navigator'; 
        else return 'navigator disabled'; 
    }
                                 }
    public String currentMonthTitle {
        get
    {
        system.debug('FORMATTED DATE---'+selectedDate+'---TITLE IS---'+datetime.newInstance(selectedDate.year(), selectedDate.month(),selectedDate.day()).format('MMMM yyyy'));
        return datetime.newInstance(selectedDate.year(), selectedDate.month(),selectedDate.day()).format('MMMM yyyy');
    }
    }
    public String apptDurationTitle {get; set;}
    public Internal_Attendee__c PrimaryUser;
    public Map<String,ID> MapOfRTIDToRTName;
    public boolean skipMonth;
    public Boolean formDisabled {
        get { return ttActivity != null && ttActivity.Private__c;}
    }
    
    public Ctrl_ClickToSchedule(Invitation__c objLink)
    {
        ttActivity = objLink;
        
    }    
    
    
    public Ctrl_ClickToSchedule(ApexPages.StandardController controller)
    {
        List<string> props;
        if (!String.isEmpty(controller.getID()))
        {
            
            List<Invitation__c> listOfInvitations = new List<Invitation__c>([select Id, Name,Criteria__c,OwnerId,Availability_Start__c,Availability_End__c,  Duration__c,Location__c, Private__c,Template__c,Web_Conference__c,Web_Conference_Password__c from Invitation__c where Id =: controller.getID()]);
            if(!listOfInvitations.isEmpty())
                ttActivity = listOfInvitations[0]; 

        }
        system.debug('activityyyy '+ttActivity);
    }
    
    
    public void init()
    {
        
        selectedDay = 0;
        skipMonth = true;
        myTTAS = new TTAppointmentWS.AppointmentWS();
        myTTCS = new TTClientServices.ClientWS();
        myTTAS.timeout_x = 60000;  
        myTTAS.SetEndpoint('callout:TimeTradeAPI' + '/AppointmentServices');
        myTTCS.SetEndpoint('callout:TimeTradeAPI' + '/ClientServices');
        myTTAS.SetSecurity('{!$Credential.UserName}', '{!$Credential.Password}');
        myTTCS.SetSecurity('{!$Credential.UserName}', '{!$Credential.Password}');
        
        //get the timezones
        TimeZoneOptions = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getDescribe();
        List<Schema.PicklistEntry> PkListEntry = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry  pkEnt : PkListEntry) {
            TimeZoneOptions.add(new SelectOption(pkEnt.getValue(), pkEnt.getValue()));
        }
        
    }
    public void setTimeZone() {
        try {
            system.debug('TimezoneNamee '+timeZoneName);
            if(timeZoneName==null) {
                List<User> meetingOwner = [SELECT id, TimeZoneSidKey from USER WHERE Id =: ttActivity.OwnerId LIMIT 1];
                strTZ = meetingOwner[0].TimeZoneSidKey;                   
                
            }
            else {
                if(timeZoneName=='Asia/Calcutta') 
                    strTz='Asia/Kolkata';
                else
                    strTz=timeZoneName;               
                
            }       
            system.debug('TimeZoneee '+timeZoneName);   
            tz = Timezone.getTimeZone(strTZ);       
            system.debug('CALLED FROM SET TIMEZONE');
            refreshMonthDays();
        }
        catch (Exception ex)
        {                      
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*   Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Error_Message__c=ex.getMessage();
Log.Exception_Type__c=ex.getTypeName();
insert Log;*/
            
        }
        return;
    }
    public Object pageLoad()
    {
        init();
        
        try
        {
            
            MapOfRTIDToRTName=new Map<String,ID>();
            String ApproverLogo = '';
            TTLinkalatorSettings__c linkSetting = TTLinkalatorSettings__c.getOrgDefaults();
            //ApproverLogo = linkSetting.Scheduler_Logo__c;             
            List<StaticResource> staticResource;
            Set <String> resourceTypeList = new Set<String> {'JPEG','JPG','PNG','jpeg','jpg','png'};
                skipMonth = true;
            //Parse the query strings
            String ttCustomerID = ApexPages.currentPage().getParameters().get('ttCustID');
            String ttRescheduleId = ApexPages.currentPage().getParameters().get('ttRescheduleId');
            List<Customer_Attendee__c> CheckForContAsso=[SELECT Name, Contact__c, Who_Id__c, Invitation__c, Meeting__c,Scheduled__c, ConfirmationNumber__c,Attendee_First_Name__c,Attendee_Last_Name__c,Attendee_Email__c,Attendee_Phone__c,Lead__c  FROM Customer_Attendee__c WHERE Id = :ttCustomerID];
            if (ttCustomerID != null && CheckForContAsso.size() > 0 )
            {
                
                //Ensure if voucher is configured, that the customer ID is valid
                ttInvitee = CheckForContAsso[0];
                System.debug('TT INVITEE---'+ttInvitee);
                List<Meeting__c> listOfMeetings =[SELECT Id, Name , Scheduled__c, Confirmation_Number__c from Meeting__c where Id =: ttInvitee.Meeting__c limit 1];
                if (listOfMeetings != null && listOfMeetings.size() > 0 )
                {
                    
                    //Ensure if voucher is configured, that the customer ID is valid
                    ttMeeting = listOfMeetings[0];
                    
                }
            }

            
            
            List<Event>EventList=[select id, Invitation__c, Confirmation_Number__c, StartDateTime, EndDateTime, Conference_Number__c from Event where id = :ttRescheduleId];
            //get the reschedule Event
            if (ttRescheduleId != null && EventList.size() > 0 )
            {
                rescheduleEvent = EventList[0];
            }
            List<Invitation_Template__c> TemplateList=[select id, Send_Confirmation_Email__c, Outlook_Invite__c from Invitation_Template__c where id = :ttActivity.Template__c];
            //get the notification template
            if (ttActivity != null && ttActivity.Template__c != null && TemplateList.size() > 0 )
            {
                ttNotifTemplate = TemplateList[0];
            }
            
            //Make sure we have enough data to load the page
            if (ttActivity == null || (ttActivity.Private__c && ttInvitee == null) || (rescheduleEvent != null && rescheduleEvent.Invitation__c != ttActivity.Id))
            {
                showErrorSection = true;
                if (ttActivity == null){errorTitle = 'Invalid Meeting Invitation';
                                        hardError = true;
                                        errorSubTitle = 'Meeting Invitation not found';
                                        errorDescription = System.Label.Click_To_Schedule_No_Meeting_Invitation; }
                else if (ttActivity.Private__c && ttCustomerID == null){errorTitle = 'Private Meeting';
                                                                        hardError = true;
                                                                        errorDescription = System.Label.Click_To_Schedule_Private_Meeting; }
                return null;
            }
            if(ttActivity != null && ttActivity.Private__c && ttInvitee != null && ttActivity.Id != ttInvitee.Invitation__c&& rescheduleEvent == null)
            {
                showErrorSection = true;
                errorTitle = 'Private Meeting';
                errorDescription = System.Label.Click_To_Schedule_Private_Meeting;
                hardError = true;
                return null;
            }
            if(ttActivity != null && ttInvitee != null && ttInvitee.Scheduled__c && rescheduleEvent == null)
            {
                system.debug('ttInviteeeeee '+ttInvitee);
                if (!String.isBlank(ttInvitee.ConfirmationNumber__c))
                {
                    //redirect
                    //get event ID
                    List<Event> bookedMeeting = [select Id from Event where Confirmation_Number__c = :ttInvitee.ConfirmationNumber__c LIMIT 1];
                    system.debug('bookedMeetinggggg '+bookedMeeting);
                    //Show Confirmation Page
                    PageReference pageRef;
                    if(TTLinkalatorSettings.Namespace_Prefix__c != null){
                        pageRef = new PageReference('/apex/' + TTLinkalatorSettings.Namespace_Prefix__c+'MeetingStatus?Id=' + bookedMeeting[0].Id+'&timeZone='+timeZoneName);
                        pageRef.setRedirect(true);                   
                        return pageRef;
                    }
                    else{
                        pageRef = new PageReference('/apex/MeetingStatus?Id=' + bookedMeeting[0].Id+'&timeZone='+timeZoneName);
                        pageRef.setRedirect(true);                   
                        return pageRef;
                    }
                    
                }
                
                showErrorSection = true;
                errorTitle = 'Meeting Scheduled';
                errorDescription = System.Label.Click_To_Schedule_Meeting_Already_Scheduled;
                hardError = true;
                return null;
            }
            
            //See if we can pre-fill the customer data
            if (ttInvitee != null)
                
            {
                //Prefill Data
                custFirstName = ttInvitee.Attendee_First_Name__c;
                custLastName = ttInvitee.Attendee_Last_Name__c;
                custEmail = ttInvitee.Attendee_Email__c;
                custPhone = ttInvitee.Attendee_Phone__c;
            }                      
            
            
            //Set Visibility 
            pageTitle = ttActivity.Name;
            showErrorSection = false;
            showAttendeeSection = true;
            showTimeSection = true;
            showClientSection = true;
            
            //Check if we are rescheduling
            if (rescheduleEvent != null)
            {
                showClientSection = false;
            }
            
            //Set the month
            if (selectedDate < ttActivity.Availability_Start__c.date()) selectedDate = ttActivity.Availability_Start__c.date().toStartOfMonth();
            if (selectedDate > ttActivity.Availability_End__c.date())
            {
                showErrorSection = true;
                errorTitle = 'Meeting invitation expired';
                errorDescription = 'This meeting invitation has expired';
                hardError = true;
                return null;
            }
            
            //Start to assemble the criteria for the appointment
            
            attendeeList = new List<Internal_Attendee__c>();
            apptCriteria = new TTAppointmentWS.appointmentCriteria();
            List<TTAppointmentWS.secondaryResourcePool> secondaryPool = new List<TTAppointmentWS.secondaryResourcePool> ();
            
            
            //Add primary resource if included
            //  if (ttActivity.Primary_Resource__c != null)
            //{
            //List<User> PrimaryUser = [select firstName, lastName, email, Title, WebEx_User__c, WebEx_Password__c from User where Id = :ttActivity.Primary_Resource__c];
            Set<id> attendeeIDs = new set<Id>();
            //List<Internal_Attendee__c> attendeeList=new List<Internal_Attendee__c>();
            
            attendeeList=[SELECT ID,Name__c,Organizer__c,Invitation__c,Name__r.Email,Name__r.firstName,Name__r.lastName,Name__r.Title,Name__r.WebEx_User__c,Name__r.WebEx_Password__c,createdDate, Name__r.SmallPhotoUrl FROM Internal_Attendee__c WHERE Invitation__c =:ttActivity.Id];
            system.debug('ATTENDEE LIST---'+attendeeList);
            for(Internal_Attendee__c Primary:attendeeList) {
                if(Primary.Organizer__c==true)
                {
                    PrimaryUser=Primary;
                    break;
                }
                else 
                    continue;
            }
            
            //  attendeeList.add(PrimaryUser[0]);
            if(PrimaryUser.Name__r.email!=null)    
                apptCriteria.resourceExternalId = PrimaryUser.Name__r.email;
            
            //add secondary resources if doing an ad-hoc meeting
            if (ttActivity.Criteria__c.toLowerCase() == 'ad-hoc meeting')
            {
                /*if (ttActivity.Secondary_Resource__c != null) attendeeIDs.add(ttActivity.Secondary_Resource__c);
if (ttActivity.Resource_3__c != null) attendeeIDs.add(ttActivity.Resource_3__c);
if (ttActivity.Resource_4__c != null) attendeeIDs.add(ttActivity.Resource_4__c);
if (ttActivity.Resource_5__c != null) attendeeIDs.add(ttActivity.Resource_5__c);*/
                //List<User> AttendingUsers=[select firstName, lastName, email, Title, WebEx_User__c, WebEx_Password__c from User where Id in :attendeeIDs];
                //if (attendeeIDs.size() > 0&&AttendingUsers.size()>0) attendeeList.addAll(AttendingUsers);
                
                for (integer i = 1; i < attendeeList.size(); i++)
                {
                    TTAppointmentWS.secondaryResourcePool currentPool = new TTAppointmentWS.secondaryResourcePool();
                    currentPool.resourceExternalId = PrimaryUser.Name__r.email;
                    currentPool.secondaryResourcePoolExternalId = string.valueOf(i);
                    List<TTApptConfiguration.secondaryResourceInfo> secondConfigList = new List<TTApptConfiguration.secondaryResourceInfo>();
                    TTApptConfiguration.secondaryResourceInfo secondConfig = new TTApptConfiguration.secondaryResourceInfo();
                    secondConfig.secondaryResourceExternalId = attendeeList[i].Name__r.email;
                    secondConfigList.add(secondConfig);
                    currentPool.secondaryResourceInfo = secondConfigList;
                    secondaryPool.add(currentPool);
                }
                
                if (secondaryPool.size() > 0) apptCriteria.secondaryResourcePool = secondaryPool; 
            }
            /*/}
/else if (ttActivity.Criteria__c.toLowerCase() == 'timetrade template' && ttActivity.TimeTrade_Activity__c != null)
{
//Get the activity from TimeTrade
showAttendeeSection = false;
}*/
            
            
            //Continue with appt Criteria
            if(ttActivity.Criteria__c.toLowerCase() == 'ad-hoc meeting')
                apptCriteria.activityExternalId =ttActivity.Duration__c.replace(' ', '');
            apptCriteria.locationExternalId = TTLinkalatorSettings.Location_External_ID__c;
            apptCriteria.programExternalId = TTLinkalatorSettings.Program_External_ID__c;           
            
            
            return null;
        }
        
        catch (Exception ex)
        {
            
            showErrorSection = true;
            errorTitle = 'Error';
            errorSubTitle = 'Line Number: ' + ex.getLineNumber();
            errorDescription = ex.getMessage();
            hardError = true;
            
            if(ex.getTypeName()=='System.CalloutException') {
                if(ex.getMessage().contains('SOAP Fault'))
                {
                    String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                    String[] truncatedError1 = truncatedError[1].split('faultcode');
                    errorDescription = truncatedError1[0];
                }
                
            }
            //Insert Debug Log object whenever there is an error
            if(!Test.isRunningTest())
                ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*  Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
//Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
            return null;
        }
        
        return null;
        
    }
    
    public void setTZ()
    {
        try{
            tz = Timezone.getTimeZone(strTZ);     
            system.debug('TimeZoneeee '+tz);          
            selectedDay = 0;
            selectedTime = 0;
            dayTimes = new List<DateControl>();
            refreshMonthDays();
        }
        catch (Exception ex)
        {           
            
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /* Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
            
        }
        
        
        return;
    }
    
    
    public void prevMonth()
    {
        try {
            selectedDate = selectedDate.addMonths(-1).toStartOfMonth();
            selectedDay = 0;
            selectedTime = 0;
            dayTimes = new List<DateControl>();
            skipMonth = false;
            refreshMonthDays();  
            
        }
        catch (Exception ex)
        {           
            
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*   Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
            
        }
    }
    
    public void nextMonth()
    {
        try{
            if(selectedDate.month()==2) {
                system.debug('INSIDE FEB---');
            }
            selectedDate = selectedDate.addMonths(1).toStartOfMonth();
            
            selectedDay = 0;
            selectedTime = 0;
            dayTimes = new List<DateControl>();
            skipMonth = false;
            refreshMonthDays();  
        }
        catch (Exception ex)
        {           
            
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*  Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
            
        }
        return;
    }
    
    public void hideError()
    {
        showErrorSection = false;
    }
    
    public void selectDay()
    {
        try
        {
            selectedTime = 0;
            
            for (DateControl currentDay: monthDays)
            {
                if (currentDay.dtDay != null && currentDay.dtDay.addseconds(tz.getOffset(currentDay.dtDay)/1000).dayGmt() == selectedDay && currentDay.dtDay.addseconds(tz.getOffset(currentDay.dtDay)/1000).monthGmt() == selectedDate.month())
                {
                    currentDay.cssClass = 'date circle focusable selected bookable';
                    currentDay.tabIndex = '0';
                }
                else if (currentDay.dtDay != null && currentDay.cssClass == 'date circle focusable selected bookable')
                {
                    currentDay.cssClass = 'date circle bookable';
                    currentDay.tabIndex = '-1';
                }
            }
            
            //Get the time slots for the day
            dayTimes = new List<DateControl>();
            if (monthSlots != null && monthSlots.size() > 0)
            {
                for (TTAppointmentWS.dateTimeSlot currentSlot: monthSlots)
                {
                    dateTime slotTime = datetime.newInstanceGmt(integer.valueOf(currentSlot.appointmentSlotTime.subString(0,4)), 
                                                                integer.valueOf(currentSlot.appointmentSlotTime.subString(5,7)), 
                                                                integer.valueOf(currentSlot.appointmentSlotTime.subString(8,10)), 
                                                                integer.valueOf(currentSlot.appointmentSlotTime.subString(11,13)), 
                                                                integer.valueOf(currentSlot.appointmentSlotTime.subString(14,16)), 0);
                
                
                if (slotTime.addseconds(tz.getOffset(slotTime)/1000).dayGmt() == selectedDay && slotTime.addseconds(tz.getOffset(slotTime)/1000).monthGmt() == selectedDate.month())
                {
                    //The slot is in the day
                        system.debug('AddTimeHere ' + selectedDay + 'Local '+ slotTime.addseconds(tz.getOffset(slotTime)/1000).day());
                        DateControl elementTime = new DateControl();
                        elementTime.cssClass = '';
                        elementTime.tabIndex = '-1';
                        elementTime.dtDay = slotTime;
                        elementTime.dataValue = String.valueOf(elementTime.dtDay.getTime());                    
                        elementTime.label = elementTime.dtDay.format('hh:mm a', tz.getID());
                        dayTimes.add(elementTime);
                    }
                }
            }
        }
        catch(Exception ex)
        {
            
            showErrorSection = true;
            errorTitle = 'Error Selecting Day';
            hardError = true;
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            errorDescription = ex.getMessage();
            
            
            if(ex.getTypeName()=='System.CalloutException') {
                if(ex.getMessage().contains('SOAP Fault'))
                {
                    String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                    String[] truncatedError1 = truncatedError[1].split('faultcode');
                    errorDescription = truncatedError1[0];
                }
                
            }
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /* Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
        }
    }
    
    public void selectTime()
    {
        try
        {
            
            for (DateControl currentTime: dayTimes)
            {
                if (currentTime.dtDay != null && currentTime.dtDay.getTime() == selectedTime)
                {
                    currentTime.cssClass = 'selected';
                    currentTime.tabIndex = '0';
                    dtSelectedTime = currentTime.dtDay;
                }
                else
                {
                    currentTime.cssClass = '';
                    currentTime.tabIndex = '-1';
                }
            }
        }
        catch(Exception ex)
        {
            showErrorSection = true;
            errorTitle = 'Error Selecting Time';
            hardError = true;
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            errorDescription = ex.getMessage();
            
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*   Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
        }
    }
    
    public Object refreshMonthDays()
    {
        try
        {
            
            monthDays = new List<DateControl>();
            monthSlots = new List<TTAppointmentWS.dateTimeSlot>();
            
            //Call Webservice to get availability for the days
            DateTime firstOfMonth = datetime.newInstanceGmt(selectedDate.year(), selectedDate.month(), 1);
            DateTime lastOfMonth = firstOfMonth.addMonths(1).addMinutes(-1);
            
            //Check for next 58 days if page is loading
            if (skipMonth)
            {
                lastOfMonth = firstOfMonth.addDays(58);
            }
            
            
            //see what weekday the first of the month lands on
            system.debug('TimeZoneee '+timeZoneName);       
            System.debug(LoggingLevel.Info,'selectedDate '+selectedDate);      
            System.debug(LoggingLevel.Info,'firsstMonnthhh '+firstOfMonth);    
            System.debug(LoggingLevel.Info,'ttActivityyyyEndd'+ttActivity.Availability_End__c);   
            System.debug(LoggingLevel.Info,'lastOfMonth'+lastOfMonth );   
            System.debug(LoggingLevel.Info,'firsstMonnthhh '+ttActivity.Availability_Start__c);   
            //ensure intersection
            if (firstOfMonth < ttActivity.Availability_End__c && lastOfMonth >= ttActivity.Availability_Start__c)
            {
                integer tzOffset = tz.getOffset(firstOfMonth);
                if (firstOfMonth < ttActivity.Availability_Start__c) 
                    firstOfMonth = ttActivity.Availability_Start__c;
                else
                    firstOfMonth = firstOfMonth.addSeconds(-1*(tzOffset/1000));
                
                if (lastOfMonth > ttActivity.Availability_End__c) 
                    lastOfMonth = ttActivity.Availability_End__c;
                else
                    lastOfMonth = lastOfMonth.addSeconds(-1*(tzOffset/1000));
                
                //Call for availability
                monthSlots = myTTAS.getAvailableNDateTimeSlotsStartFromDate(apptCriteria, firstOfMonth, lastOfMonth, 500);
                
                if (monthSlots == null || monthSlots.size() == 0){
                   system.debug('firsttmonthhh '+firstOfMonth);
                    monthSlots = myTTAS.getAvailableNDateTimeSlotsStartFromDate(apptCriteria, firstOfMonth, lastOfMonth, 500);
                    system.debug('monthSlotssss '+monthSlots);
                    Debug_Log__c Log=new Debug_Log__c();
                    Log.Line_Number__c=603;
                    Log.Record_Detail__c=ttActivity.ID;
                    Log.Error_Description__c='Error Getting Month Slots';
                    Log.Exception_Type__c='Call Out Exception';
                    Log.Error_Message__c='No Slots Returned. Exchnage Failure';
                    insert Log;
                }
            }
            else
            {
                
            }
            System.debug(LoggingLevel.Info,'MONTH SLOT--'+ monthSlots);
            
            
            if (monthSlots == null || monthSlots.size() == 0)
            {
                //Nothing returned
                showErrorSection = true;
                errorTitle = 'No Availability';
                errorDescription = System.Label.Click_To_Schedule_No_Availability;
                hardError = false;
                //system.debug('Monthhh '+monthSlots);
            }
            
            if (monthSlots != null && monthSlots.size() > 0) 
            {
                apptDurationTitle = string.valueOf(monthSlots[0].lengthinMin) + ' minute meeting';
                dateTime firstSlotTime = datetime.newInstanceGmt(integer.valueOf(monthSlots[0].appointmentSlotTime.subString(0,4)), 
                                                                 integer.valueOf(monthSlots[0].appointmentSlotTime.subString(5,7)), 
                                                                 integer.valueOf(monthSlots[0].appointmentSlotTime.subString(8,10)), 
                                                                 integer.valueOf(monthSlots[0].appointmentSlotTime.subString(11,13)), 
                                                                 integer.valueOf(monthSlots[0].appointmentSlotTime.subString(14,16)), 0);
                //Convert the First Slot Time to local time to display the right month on the calendar
                DateTime firstSlotTimeLocal = firstSlotTime.addseconds((tz.getOffset(firstSlotTime)/1000));

                //
                firstOfMonth = datetime.newInstanceGmt(firstSlotTimeLocal.yearGmt(), firstSlotTimeLocal.monthGmt(), 1);
                lastOfMonth = firstOfMonth.addMonths(1).addMinutes(-1);
                selectedDate = date.newInstance(firstOfMonth.yearGmt(), firstOfMonth.monthGmt(), 1);
                
            }
            
            Date baseDate = Date.newInstance(0001, 1, 2);
            integer counter = 0;
            integer offset = Math.mod(baseDate.daysBetween(firstOfMonth.dateGmt()), 7);
            
            
            //First fill buffer dates
            for (integer i = 0; i < offset; i++)
            {
                DateControl bufferDate = new DateControl();
                bufferDate.cssClass = 'date empty';
                bufferDate.tabIndex = '-1';
                bufferDate.dataValue = '';
                bufferDate.dayNumber = '';
                bufferDate.label = '';
                bufferDate.title = '';
                monthDays.add(bufferDate);
                counter ++;
            }
            system.debug('monthDays---: ' + monthDays);
            system.debug('selectedDateeee---: ' + selectedDate);
            //Next add actual dates
            for (integer i = 1; i <= selectedDate.addMonths(1).toStartofMonth().addDays(-1).day(); i++)
            {
                datetime currentDay = datetime.newInstanceGmt(selectedDate.year(), selectedDate.month(),i);
                currentDay = currentDay.addseconds(-1*(tz.getOffset(currentDay)/1000));
                DateControl elementDate = new DateControl();
                elementDate.dtDay = currentDay;
                
                if (selectedDay > 0 && selectedDay == i && isBookable(i, selectedDate.month()))
                {
                    
                    elementDate.cssClass = 'date circle focusable selected bookable';
                    elementDate.title = 'Times available';
                    elementDate.tabIndex = '0';
                    elementDate.label = currentDay.formatGmt('EEEE, MMMMM dd, yyyy') + '. Times available';
                }
                else if(isBookable(i, selectedDate.month()))
                {
                    elementDate.cssClass = 'date circle bookable';
                    elementDate.tabIndex = '-1';
                    elementDate.title = 'Times available';
                    elementDate.label = currentDay.formatGmt('EEEE, MMMMM dd, yyyy') + '. Times available';
                }
                else
                {
                    elementDate.cssClass = 'date circle not-bookable';
                    elementDate.tabIndex = '-1';
                    elementDate.title = 'No available times';
                    elementDate.label = currentDay.formatGmt('EEEE, MMMMM dd, yyyy') + '. No available times';
                }
                elementDate.dayNumber = String.valueOf(i);
                elementDate.dataValue = currentDay.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
                monthDays.add(elementDate);
                system.debug('monthDays---: ' + monthDays);
                counter ++;
            }
            
            //finally fill buffer dates
            while (Math.mod(counter, 7) != 0)
            {
                DateControl bufferDate = new DateControl();
                bufferDate.cssClass = 'date empty';
                bufferDate.tabIndex = '-1';
                bufferDate.dataValue = '';
                bufferDate.dayNumber = '';
                bufferDate.label = '';
                bufferDate.title = '';
                monthDays.add(bufferDate);
                counter ++;
            }
        }
        catch (Exception ex)
        {           
            
            showErrorSection = true;
            errorTitle = 'Error Fetching Availability';
            hardError = true;
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            
            
            if(ex.getTypeName()=='System.CalloutException') {
                if(ex.getMessage().contains('SOAP Fault'))
                {
                    String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                    String[] truncatedError1 = truncatedError[1].split('faultcode');
                    errorDescription = truncatedError1[0];
                }
                
            }
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*   Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
            //system.debug('ERROR IS---'+Log);
            return null;
        }
        
        return null;
    }
    
    public boolean isBookable(integer currentDay, integer currentMonth)
    {
        try{
            if (monthSlots != null && monthSlots.size() > 0)
            {
                for (integer i = 0; i < monthSlots.size(); i++)
                {
                    dateTime currentSlot = datetime.newInstanceGmt(integer.valueOf(monthSlots[i].appointmentSlotTime.subString(0,4)), 
                                                                   integer.valueOf(monthSlots[i].appointmentSlotTime.subString(5,7)), 
                                                                   integer.valueOf(monthSlots[i].appointmentSlotTime.subString(8,10)), 
                                                                   integer.valueOf(monthSlots[i].appointmentSlotTime.subString(11,13)), 
                                                                   integer.valueOf(monthSlots[i].appointmentSlotTime.subString(14,16)), 0);
                    
                    //Adjust currentSlot to be in the local timezone
                    currentSlot = currentSlot.addseconds((tz.getOffset(currentSlot)/1000));
                    if (currentSlot.dayGmt() == currentDay && currentSlot.monthGmt() == currentMonth) return true;
                }
            }
        }
        catch (Exception ex)
        {           
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*      Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
            return null;
        }
        
        return false;
    }
    
    public PageReference bookAppointment()
    {
        TTAppointmentServices.appointment appointment;
        Event newMeeting = new Event();
        
        
        try
        {
            if (!validateForm()) return null;
            
            //first update/insert the client
            TTClientServices.client ttClient = new TTClientServices.client();
            ttClient.email = custEmail;
            ttClient.clientExternalId = 'test@lister.com';
            ttClient.firstName = custFirstName;
            ttClient.lastName = custLastName;
            if (custPhone != null && custPhone != '')
            {
                ttClient.phoneData = new TTClientServices.phoneData();
                ttClient.phoneData.mobile = custPhone;
            }
            ttClient.applyTimeZone = false;
            ttClient.rulesGroupExternalId = 'client';
            ttClient.userGroupExternalId = 'client';
            TTClientServices.TTStatus clientStatus = new TTClientServices.TTStatus();
            if(!Test.isRunningTest()) clientStatus = myTTCS.updateInsertClient(ttClient, DateTime.now());
            system.debug('clientStatus: ' + clientStatus.result);
            
            //next book the appointment
            TTAppointmentWS.TTStatus apptStatus = new TTAppointmentWS.TTStatus();
            //dtSelectedTime=date.today().addDays(-10);
            if(!Test.isRunningTest()) {apptStatus = myTTAS.bookAppointment(apptCriteria, dtSelectedTime, ttClient.clientExternalId);
                                       
                                      }
            appointment = new TTAppointmentServices.appointment();
            appointment.confirmationNumber = apptStatus.result;
            
            //Get the most recent Appointment if needed
            TTAppointmentServices.appointment updatedAppointment;
            if (ttActivity.Criteria__c.toLowerCase() == 'timetrade template')
            {
                TTAppointmentWS.appointmentByConfirmationNumberStatus apptDetails = myTTAS.getAppointmentByConfirmationNumber(appointment.confirmationNumber);
                updatedAppointment = apptDetails.appointment;
                
                if (attendeeList.size() == 0)
                {
                    //Add the primary resource
                    List<Internal_Attendee__c> assignedPrimaryUser=  [select id,Invitation__c,Name__c,Name__r.firstName, Name__r.lastName, Name__r.email, Name__r.Title, Name__r.WebEx_User__c,  Name__r.WebEx_Password__c from Internal_Attendee__c WHERE Name__r.email =: updatedAppointment.resourceExternalId LIMIT 1];
                    newMeeting.OwnerId = assignedPrimaryUser[0].Name__c;
                    attendeeList.addAll(assignedPrimaryUser);
                    PrimaryUser=assignedPrimaryUser[0];
                }
            }
            else
            {
                newMeeting.OwnerId = PrimaryUser.Name__c;
            } 
            
            //Update the Invitation to show that its booked if voucher is enabled
            if (ttInvitee != null)
            {
                ttInvitee.Scheduled__c = true;
                ttInvitee.ConfirmationNumber__c = appointment.confirmationNumber;
                update ttInvitee;
            }

            if (ttMeeting != null)
            {
                ttMeeting.Scheduled__c = true;
                ttMeeting.Confirmation_Number__c = appointment.confirmationNumber;
                update ttMeeting;
                newmeeting.Meeting__c = ttMeeting.Id;
            }
            
            
            system.debug('confffff '+ttActivity);     
            Invitation__c meetInvite = [select Web_Conference__c,Web_Conference_Password__c from Invitation__c where Id =: ttActivity.Id];
            //Start populating the event object
            newmeeting.Invitation__c = ttActivity.Id;
            newMeeting.Subject = ttActivity.Name;
            newMeeting.StartDateTime = dtSelectedTime;
            newMeeting.EndDateTime = dtSelectedTime.addMinutes(monthSlots[0].lengthinMin);
            newMeeting.ReminderDateTime = dtSelectedTime.addMinutes(-15);
            newMeeting.Description = apptNotes;
            newMeeting.Location = ttActivity.Location__c;
            newMeeting.Confirmation_Number__c = appointment.confirmationNumber;
            newMeeting.Conference_Provider__c = meetInvite.Web_Conference__c;
            newMeeting.Conference_Secret__c  = meetInvite.Web_Conference_Password__c;
            newMeeting.Meeting_Status__c = 'Scheduled';

            
            //assign to Contact or lead
            ID accID;
            String sObj = '';
            if(String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = 'Customer_Attendee__c';
            else if(!String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = TTLinkalatorSettings.Namespace_Prefix__c + 'Customer_Attendee__c';
            
            for(RecordType RT:[select id,sobjecttype,developername  from recordtype where sobjecttype=: sObj]) {
                MapOfRTIDToRTName.put(RT.developername,RT.id);
            }
            List<Contact> ContactList=[select id, AccountID from Contact WHERE email=:custEmail Limit 1];
            if (ttInvitee != null) 
                
            {
                if(ttInvitee.Who_ID__c != null)
                    newMeeting.WhoId = ttInvitee.Who_ID__c; 
                else if(ttInvitee.Who_ID__c == null && ttInvitee.RecordTypeId==MapOfRTIDToRTName.get('Contact_Related'))
                    newMeeting.WhoId = ttInvitee.Contact__c;
                else if(ttInvitee.Who_ID__c == null && ttInvitee.RecordTypeId==MapOfRTIDToRTName.get('Lead_Related'))
                    newMeeting.WhoId = ttInvitee.Lead__c;    
                system.debug('INSIDE 3');
                
            }
            else if (ContactList.size() > 0)
            {
                //Search for a contact
                Contact c = ContactList[0];
                accID = c.AccountId;
                newMeeting.WhoId = c.Id;
                system.debug('INSIDE 2');
            }
            else
            {
                //Create Contact
                Contact newContact = new Contact();
                newContact.FirstName = custFirstName;
                newContact.LastName = custLastName;
                newContact.Email = custEmail;
                newContact.MobilePhone = custPhone;
                
                insert newContact;
                newMeeting.WhoId = newContact.Id;
                system.debug('INSIDE 1');
                
            }
            
            system.debug('NEW MEETIN 1---'+newMeeting);
            if(custAttendeeList != '' || custAttendeeList != null)
                newMeeting.Additional_Contacts__c = custAttendeeList;
            
            
            //Insert the meeting
            insert newMeeting;           
            
            if(ttActivity.web_conference__c == null)
            {
                //Lastly, send the confirmation email if selected
                if (ttNotifTemplate != null && ttNotifTemplate.Send_Confirmation_Email__c)
                {
                    newMeeting.Trigger_Confirmation_Email__c = true;
                    update newMeeting;
                }
            }
            
            
        }
        catch(System.Exception ex) {
            
            showErrorSection = true;
            errorTitle = 'Error Scheduling Meeting';
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            errorDescription = ex.getMessage();
            
            if(ex.getTypeName()=='System.CalloutException') {
                if(ex.getMessage().contains('SOAP Fault'))
                {
                    String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                    String[] truncatedError1 = truncatedError[1].split('faultcode');
                    errorDescription = truncatedError1[0];
                }
                
            }
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
            return null;
        }
        
        //Show Confirmation Page
        PageReference pg = Page.MeetingStatus;
        pg.setRedirect(true);
        pg.getParameters().put('id',newMeeting.Id); 
        pg.getParameters().put('timeZone',timeZoneName); 
        
        return pg;
        
        
    }
    
    public PageReference rescheduleAppointment()
    {
        try
        {
            if (!validateForm()) return null;
            
            //First Reschedule the meeting in TimeTrade
            if (!Test.isRunningTest())TTAppointmentWS.TTStatus apptStatus = myTTAS.rescheduleAppointment(rescheduleEvent.Confirmation_Number__c, dtSelectedTime);
            
            
            
            //Then update the event
            rescheduleEvent.StartDateTime = dtSelectedTime;
            rescheduleEvent.EndDateTime = dtSelectedTime.addMinutes(monthSlots[0].lengthinMin);
            rescheduleEvent.ReminderDateTime = dtSelectedTime.addMinutes(-15);
            update rescheduleEvent;
            
            //redirect to the apptStatus Page
            PageReference pageRef = new PageReference('/apex/MeetingStatus?Id=' + rescheduleEvent.Id+'&timeZone='+timeZoneName);
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch (Exception ex)
        {
            showErrorSection = true;
            errorTitle = 'Error rescheduling Meeting';
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            errorDescription = ex.getMessage();
            
            if(ex.getTypeName()=='System.CalloutException') {
                if(ex.getMessage().contains('SOAP Fault'))
                {
                    String[] truncatedError = ex.getMessage().split('SOAP Fault:');
                    String[] truncatedError1 = truncatedError[1].split('faultcode');
                    errorDescription = truncatedError1[0];
                }
                
            }
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),ttActivity.ID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*   Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
        }
        return null;
    }
    
    public boolean validateForm()
    {
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        if((rescheduleEvent == null && (custFirstName == '' || custLastName == '' || custEmail == '' || !Pattern.matches(emailRegex, custEmail.trim())))){
            showErrorSection = true;
            errorTitle = 'Missing Information';
            errorSubTitle = 'Some required information is missing';
            errorDescription = System.Label.Click_To_Schedule_Required_Information_Missing;
            hardError = false;
            return false;
        }
        if (selectedDay == 0 || selectedTime == 0 )
        {
            showErrorSection = true;
            errorTitle = 'Missing Information';
            errorSubTitle = 'Some required information is missing';
            errorDescription = System.Label.Click_To_Schedule_Invalid_Slot_or_Invalid_Information;
            hardError = false;
            return false;
        }
        
        return true;
    }
    
    
}