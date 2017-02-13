public class TimeTradeBookNowController {
    public List<DateControl> monthDays{get; set;}
    public List<DateControl> dayTimes{get; set;}
    public TTAppointmentWS.dateTimeSlot[] monthSlots {get; set;}
    private Id contactId;
    public Id leadId;
    private Date selectedDate = date.today();
    public integer selectedDay {get; set;}
    public long selectedTime {get; set;}
    public DateTime dtselectedTime {get; set;}
    public List<SelectOption> TimeZoneOptions {get; set;}
    public Timezone tz = Timezone.getTimeZone('America/New_York');
    public string strTZ {get; set;}
    public string timeZoneName{get;set;}   
    public List<SelectOption> SlotTypeOptions {get; set;}
    public string strSlotType {get; set;}
    
    public List<SelectOption> ConfProviderOptions {get; set;}
    public string strConfProvider {get; set;}
    public String WebConferencePassword {get; set;}
    
    
    TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
    
    public Invitation_Template__c ttNotifTemplate {get;set;}
    TTAppointmentWS.AppointmentWS myTTAS;
    TTClientServices.ClientWS myTTCS;
    TTAppointmentWS.appointmentCriteria apptCriteria;
    
    public Boolean showErrorSection{get;set;}
    public Boolean hardError{get;set;}
    public Boolean showTimeSection{get;set;}
    public Boolean showClientSection{get;set;}
    public String pageTitle {get; set;}
    public String errorTitle {get; set;}
    public String errorSubTitle {get; set;}
    public String errorDescription {get; set;}
    public List<User> attendeeList {get; set;}
    public Id objId;
   // public Contact clientContact {get; set;}
    public Sobject ClientDetails{get;set;}
  //  public Lead clientLead {get; set;}
    public String meetingInstructions {get; set;}
    public String custAttendeeList {get; set;}
    
    public Boolean skipMonth;
    public String prevMonthClass {get
    {
        if (selectedDate.toStartofMonth() > Date.today().toStartofMonth()) 
            return 'navigator'; 
        else return 'navigator disabled'; 
    }
                                 }
    public String nextMonthClass {get
    {
          
        if (selectedDate <= Date.today().addMonths(6))
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

    public Boolean formDisabled {get; set;}
    
     // Instance fields
    public String MeetingName {get; set;}
    public String MeetingLocation {get; set;}

    public String searchTemplateTerm {get; set;}
    public String selectedTemplate {get; set;}
    
    Public Set<id> userSearchCache {get; set;}
    public String searchResource1Term {get; set;}
    public String selectedResource1 {get; set;}
    public String searchResource2Term {get; set;}
    public String selectedResource2 {get; set;}
    public String searchResource3Term {get; set;}
    public String selectedResource3 {get; set;}
    public String searchResource4Term {get; set;}
    public String selectedResource4 {get; set;}
    public String searchResource5Term {get; set;}
    public String selectedResource5 {get; set;}
    public List<Id> attendeeIDs;
    // JS Remoting action called when searching for a movie name
    @RemoteAction
    public static List<Invitation_Template__c> searchTemplate(String searchTerm) {
        System.debug('Template Name is: '+searchTerm );
        List<Invitation_Template__c> templates = Database.query('Select Id, Name from Invitation_Template__c where name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        return templates;
    }
    
    // JS Remoting action called when searching for a movie name
    @RemoteAction
    public static List<User> searchResource(String searchTerm) {
        System.debug('Resource Name is: '+searchTerm );
        List<User> users = Database.query('Select Name, firstName, lastName, email, Title from User where IsActive=true and name like \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        return users;
    }
    
        
    public TimeTradeBookNowController(ApexPages.StandardController controller)
    {
        if (String.isNotBlank(controller.getId())){
             objId = controller.getId();
             init();
         }
    }
    
    public void init()
    {
        //contactId = contactId;
        try {
          skipMonth = true;
            userSearchCache = new Set<Id>();
            if(objId!= null){
                if(objId.getSobjectType().getDescribe().getName() == 'Contact'){
                    contactId = objId;
                }
                else if(objId.getSobjectType().getDescribe().getName() == 'Lead'){
                    leadId = objId;
                }
                else{
                    showErrorSection = true;
                    hardError = true;
                    errorTitle = 'Error Retrieving Record';
                    //errorSubTitle = 'Line :' + ex.getLineNumber();
                    errorDescription = 'Not a Valid Record';
                    return;
                }
            }
            if(objId!=null) {
              
              String objectName=objId.getSobjectType().getDescribe().getName();
                Schema.SObjectType convertType = Schema.getGlobalDescribe().get(objectName);
                
                Sobject genericObject = convertType.newSObject();
                system.debug('SBOJECT genericObject IS---'+genericObject);
                List<String> FieldList=new List<String>{'Name','FirstName','LastName','Email','Phone'};
                if(hasSObjectField(FieldList,objectName)) {
                  String QueryForDetails='SELECT Name, FirstName, LastName, Email, Phone FROM '+objectName+' WHERE ID=\''+objId+'\''+' LIMIT 1' ;
                    system.debug('QUERY IS--'+QueryForDetails);
                 ClientDetails=Database.query(QueryForDetails); 
                    
                    
                }
                else  {
                    showErrorSection = true;
                    hardError = true;
                    errorTitle = 'Error Loading Contact';
                    //errorSubTitle = 'Line :' + ex.getLineNumber();
                    // HAVE TO CHANGE THIS TO A LABEL
                   // errorDescription = System.Label.Book_Now_Required_Contact_Details_Are_Missing;
                }
            }
           /* if(contactId != null){
                
                if (clientContact == null) clientContact = [SELECT Name, FirstName, LastName, Email, Phone FROM Contact WHERE Id = :contactId LIMIT 1];  
            
                if(clientContact == null || (clientContact!= null && String.isBlank(clientContact.Email))){
                    showErrorSection = true;
                    hardError = true;
                    errorTitle = 'Error Loading Contact';
                    //errorSubTitle = 'Line :' + ex.getLineNumber();
                    errorDescription = System.Label.Book_Now_Required_Contact_Details_Are_Missing;
                } 
            }
            else if(leadId != null){
                if (clientLead == null) clientLead  = [SELECT Name, FirstName, LastName, Email, Phone FROM Lead WHERE Id = :leadId LIMIT 1];  
            
                if(clientLead == null || (clientLead != null && String.isBlank(clientLead .Email))){
                    showErrorSection = true;
                    hardError = true;
                    errorTitle = 'Error Loading Lead';
                    //errorSubTitle = 'Line :' + ex.getLineNumber();
                    errorDescription = System.Label.Book_Now_Required_Details_Are_Missing;
                } 
            }*/
            
            
            
        }
        catch(Exception ex)
        {
             ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

            showErrorSection = true;
            hardError = true;
            system.debug('Exception: ' + ex.getMessage());
            errorTitle = 'Error Retrieving Contact';
            errorSubTitle = 'Line :' + ex.getLineNumber();
            errorDescription = ex.getMessage();
            return;
        }
        
        //Initiate the callouts
        selectedDay = 0;
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
        strTZ = UserInfo.getTimeZone().getID();
        tz = Timezone.getTimeZone(strTZ);
        
        //Get the Slot Types
        SlotTypeOptions = new List<SelectOption>();
        Schema.DescribeFieldResult slotTypeResult = Invitation__c.Duration__c.getDescribe();
        List<Schema.PicklistEntry> slotTypePkListEntry = slotTypeResult.getPicklistValues();
        for( Schema.PicklistEntry  pkEnt : slotTypePkListEntry) {
            SlotTypeOptions.add(new SelectOption(pkEnt.getValue(), pkEnt.getValue()));
        }
        strSlotType = SlotTypeOptions.get(0).getValue();
        
        //Get the Conf Providers
        ConfProviderOptions = new List<SelectOption>();
        Schema.DescribeFieldResult confProviderResult = Invitation__c.Web_Conference__c.getDescribe();
        List<Schema.PicklistEntry> confProviderPkListEntry = confProviderResult.getPicklistValues();
        ConfProviderOptions.add(new SelectOption('', '--none--'));
        for( Schema.PicklistEntry  pkEnt : confProviderPkListEntry) {
            ConfProviderOptions.add(new SelectOption(pkEnt.getValue(), pkEnt.getValue()));
        }
        
        
        //Set the organizer
        List<User> primaryResource = [SELECT Name FROM USER WHERE ID=: UserInfo.getUserID()];
        selectedResource1 = primaryResource[0].id;
        searchResource1Term = primaryResource[0].Name;
        
        
        //Show the Availability
        formDisabled = true;
        setCriteria();
        
    }

    public void setTimeZone() {
        try {
            if(timeZoneName==null) {
                List<User> meetingOwner = [SELECT id, TimeZoneSidKey from USER WHERE Id =: UserInfo.getUserId() LIMIT 1];
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
            CriteriaChanged();
        }
        catch (Exception ex)
        {                      
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),objId,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
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
        system.debug('loading page...');
        showTimeSection = true;
        showClientSection = true;
        return null;
    }
    
    public void prevMonth()
    {
        skipMonth = false;
        selectedDate = selectedDate.addMonths(-1).toStartOfMonth();
        selectedDay = 0;
        selectedTime = 0;
        dayTimes = new List<DateControl>();
        refreshMonthDays();
    }
    
    public void nextMonth()
    {
        skipMonth = false;
        system.debug('next Month Called...');
        selectedDate = selectedDate.addMonths(1).toStartOfMonth();
        selectedDay = 0;
        selectedTime = 0;
        dayTimes = new List<DateControl>();
        refreshMonthDays();
        return;
    }
    
    public boolean setCriteria()
    {
        try
        {
            system.debug('setting criteria:resource1' + selectedResource1 + ' slotType:' + strSlotType);
            //Start to assemble the criteria for the appointment
            attendeeList = new List<User>();
            apptCriteria = new TTAppointmentWS.appointmentCriteria();
            List<TTAppointmentWS.secondaryResourcePool> secondaryPool = new List<TTAppointmentWS.secondaryResourcePool> ();
            
            //Add primary resource if included
            if (!String.isBlank(selectedResource1) && !String.isBlank(strSlotType))
            {
                List<User> PrimaryUser = [select ID, Name, firstName, lastName, email, Title, TimeZoneSidKey from User where Id = :selectedResource1];
                attendeeIDs = new List<Id>();
                attendeeList.add(PrimaryUser[0]);
                apptCriteria.resourceExternalId = PrimaryUser[0].email;
                if(!userSearchCache.contains(PrimaryUser[0].Id))
                {
                    userSearchCache.add(PrimaryUser[0].Id);
                   UtilClass.copyCheckResource(PrimaryUser[0].email, PrimaryUser[0].Name, PrimaryUser[0].TimeZoneSidKey);
                }
                
                if (!String.isBlank(selectedResource2)) attendeeIDs.add(selectedResource2);
                if (!String.isBlank(selectedResource3)) attendeeIDs.add(selectedResource3);
                if (!String.isBlank(selectedResource4)) attendeeIDs.add(selectedResource4);
                if (!String.isBlank(selectedResource5)) attendeeIDs.add(selectedResource5);
                system.debug('attendeees '+attendeeIDs);
                if (attendeeIDs.size() > 0) attendeeList.addAll([select ID, Name, firstName, lastName, email, Title, TimeZoneSidKey from User where Id in :attendeeIDs]);
                for (integer i = 1; i < attendeeList.size(); i++)
                {
                    if(!userSearchCache.contains(attendeeList[i].Id))
                    {
                        userSearchCache.add(attendeeList[i].Id);
                       UtilClass.copyCheckResource(attendeeList[i].email, attendeeList[i].Name, attendeeList[i].TimeZoneSidKey);
                  }
                    TTAppointmentWS.secondaryResourcePool currentPool = new TTAppointmentWS.secondaryResourcePool();
                    currentPool.resourceExternalId = attendeeList[0].email;
                    currentPool.secondaryResourcePoolExternalId = string.valueOf(i);
                    List<TTApptConfiguration.secondaryResourceInfo> secondConfigList = new List<TTApptConfiguration.secondaryResourceInfo>();
                    TTApptConfiguration.secondaryResourceInfo secondConfig = new TTApptConfiguration.secondaryResourceInfo();
                    secondConfig.secondaryResourceExternalId = attendeeList[i].email;
                    secondConfigList.add(secondConfig);
                    currentPool.secondaryResourceInfo = secondConfigList;
                    secondaryPool.add(currentPool);
                }
                System.debug('Primary Resource: ' + PrimaryUser[0].Name);
                System.debug('secondary poolSize: ' + string.valueOf(secondaryPool.size()));
                if (secondaryPool.size() > 0) apptCriteria.secondaryResourcePool = secondaryPool; 
            }
            else
            {
                system.debug('Invalid Criteria: Slot Type:' + strSlotType + ' User:' + selectedResource1);
                return false;
            }
            
            //Continue with appt Criteria
            apptCriteria.activityExternalId = strSlotType.replace(' ', '');
            apptCriteria.locationExternalId = TTLinkalatorSettings.Location_External_ID__c;
            apptCriteria.programExternalId = TTLinkalatorSettings.Program_External_ID__c;
            
            return true;
        }
        catch(Exception ex)
        {
            showErrorSection = true;
            errorTitle = 'Error Setting Criteria';
            hardError = true;
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            errorDescription = ex.getMessage();
             ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

            system.debug('Exception: ' + ex.getMessage());
        }
        
        return false;
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
            System.debug(LoggingLevel.Info,'lastOfMonth'+lastOfMonth );   
            //ensure intersection
            //Call for availability
            monthSlots = myTTAS.getAvailableNDateTimeSlotsStartFromDate(apptCriteria, firstOfMonth, lastOfMonth, 500);
            
            if (monthSlots == null || monthSlots.size() == 0){
                system.debug('firsttmonthhh '+firstOfMonth);
                monthSlots = myTTAS.getAvailableNDateTimeSlotsStartFromDate(apptCriteria, firstOfMonth, lastOfMonth, 500);
                system.debug('monthSlotssss '+monthSlots);
                Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=603;
                Log.Error_Description__c='Error Getting Month Slots';
                Log.Exception_Type__c='Call Out Exception';
                Log.Error_Message__c='No Slots Returned. Exchnage Failure';
                insert Log;
            }
            
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
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),objId,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
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
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),objId,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            return null;
        }
        
        return false;
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
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),objId,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
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
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),objId,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            
            /*   Debug_Log__c Log=new Debug_Log__c();
Log.Line_Number__c=ex.getLineNumber();
Log.Record_Detail__c=ttActivity.ID;
Log.Error_Description__c=ex.getStackTraceString();
Log.Exception_Type__c=ex.getTypeName();
Log.Error_Message__c=ex.getMessage();
insert Log;*/
        }
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
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),objId,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
        }
        
        
        return;
    }
    
    public void CriteriaChanged()
    {
        system.debug('slot type changing...');
        system.debug('Primary String:' + searchResource1Term);
        system.debug('Primary ID:' + selectedResource1);
        
        selectedDay = 0;
        selectedTime = 0;
        dayTimes = new List<DateControl>();
        monthDays = new List<DateControl>();
        if (setCriteria()) refreshMonthDays();
    }
    
    public PageReference bookAppointment()
    {
        TTAppointmentServices.appointment appointment;
        Event newMeeting = new Event();
        savepoint sp;       
        try
        {
            if(MeetingName== null || MeetingName==''){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Meeting Subject is Missing'));
                showErrorSection = true;
                errorTitle = 'Error Scheduling Meeting';
                //errorSubTitle = 'Meeting Subject is Missing';
                errorDescription = System.Label.Book_Now_No_Meeting_Subject;
                return null;
            }
            if(selectedTemplate == null || selectedTemplate==''){
                showErrorSection = true;
                errorTitle = 'Error Scheduling Meeting';
                //errorSubTitle = 'Meeting Subject is Missing';
                errorDescription = System.Label.Book_Now_No_Notification_Template;
                return null;
            }
            
            if (!validateForm()) return null;
            
            //first update/insert the client
            TTClientServices.client ttClient = new TTClientServices.client();
        //CHANGES MADE BY SAI
            if(ClientDetails!=null) {
                ttClient.email = (String)ClientDetails.get('Email');
                ttClient.clientExternalId =(String) ClientDetails.get('Email');
                ttClient.firstName = (String) ClientDetails.get('FirstName');
                ttClient.lastName =  (String) ClientDetails.get('LastName');
                if (!String.isBlank((String) ClientDetails.get('Phone')))
                {
                    ttClient.phoneData = new TTClientServices.phoneData();
                    ttClient.phoneData.mobile = (String) ClientDetails.get('Phone');
                }
            }
        /*    if(clientContact != null){
                ttClient.email = clientContact.Email;
                ttClient.clientExternalId = clientContact.Email;
                ttClient.firstName = clientContact.FirstName;
                ttClient.lastName = clientContact.LastName;
                if (!String.isBlank(clientContact.Phone))
                {
                    ttClient.phoneData = new TTClientServices.phoneData();
                    ttClient.phoneData.mobile = clientContact.Phone;
                }
            }
            else if(clientLead != null ){
                ttClient.email = clientLead.Email;
                ttClient.clientExternalId = clientLead.Email;
                ttClient.firstName = clientLead.FirstName;
                ttClient.lastName = clientLead.LastName;
                if (!String.isBlank(clientLead.Phone))
                {
                    ttClient.phoneData = new TTClientServices.phoneData();
                    ttClient.phoneData.mobile = clientLead.Phone;
                }
            }*/
            
            ttClient.applyTimeZone = false;
            ttClient.rulesGroupExternalId = 'client';
            ttClient.userGroupExternalId = 'client';
            TTClientServices.TTStatus clientStatus = new TTClientServices.TTStatus();
            if(!Test.isRunningTest()) clientStatus = myTTCS.updateInsertClient(ttClient, DateTime.now());
            system.debug('clientStatus: ' + clientStatus.result);
            
            //next book the appointment
            TTAppointmentWS.TTStatus apptStatus = new TTAppointmentWS.TTStatus();
            if(!Test.isRunningTest()) apptStatus = myTTAS.bookAppointment(apptCriteria, dtSelectedTime, ttClient.clientExternalId);
            system.debug('apptStatus: ' + apptStatus.result);
            appointment = new TTAppointmentServices.appointment();
            appointment.confirmationNumber = apptStatus.result;
            sp = database.setsavepoint(); 
            //assign to Contact or lead
            ID accID;
            if (ObjId != null)
            {
                newMeeting.WhoId = ObjId;
            }
            
            
            //Create the Meeting Invitation
            Invitation__c ttActivity = new Invitation__c();
            ttActivity.Name = MeetingName;
            ttActivity.Location__c = MeetingLocation;
            ttActivity.Criteria__c = 'Ad-Hoc Meeting';
            ttActivity.Duration__c = strSlotType;
            
            if (!String.isBlank(selectedTemplate))
            {
                ttNotifTemplate = [select id, Send_Confirmation_Email__c, Outlook_Invite__c from Invitation_Template__c where id = :selectedTemplate];
                ttActivity.Template__c = ttNotifTemplate.Id;
            }
            //contactId = ApexPages.currentPage().getParameters().get('Id');
            if (String.isNotBlank(strConfProvider)) ttActivity.Web_Conference__c = strConfProvider;
            ttActivity.Web_Conference_Password__c = WebConferencePassword;
            //ttActivity.Primary_Contact__c = newMeeting.WhoId;
            ttActivity.Private__c = true;
            ttActivity.Notes__c= meetingInstructions;
            ttActivity.Availability_Start__c = DateTime.now();
            ttActivity.Availability_End__c = ttActivity.Availability_Start__c.addDays(90);
            system.debug('contactIddddd '+contactId);
            ttActivity.Who_ID__c = ObjId;
            //Insert the resources
            /*ttActivity.Primary_Resource__c = selectedResource1;
            if (!String.isBlank(selectedResource2)) ttActivity.Secondary_Resource__c = selectedResource2;
            if (!String.isBlank(selectedResource3)) ttActivity.Resource_3__c = selectedResource3;
            if (!String.isBlank(selectedResource4)) ttActivity.Resource_4__c = selectedResource4;
            if (!String.isBlank(selectedResource5)) ttActivity.Resource_5__c = selectedResource5;*/
            insert ttActivity;

            //Get the invitation and update it to show that its booked
            List<Customer_Attendee__c> ttInvitee = [SELECT Name, Contact__c, Lead__c , Invitation__c, Scheduled__c, Meeting__C, ConfirmationNumber__c FROM Customer_Attendee__c WHERE Invitation__c = :ttActivity.Id AND (Contact__c = : objId OR Lead__c =: objId ) LIMIT 1];
            if (ttInvitee.size()>0)
            {
                ttInvitee[0].Scheduled__c = true;
                ttInvitee[0].ConfirmationNumber__c = appointment.confirmationNumber;
                update ttInvitee[0];

                   List<Meeting__c> ttMeeting =[SELECT Id, Name , Scheduled__c, Confirmation_Number__c from Meeting__c where Id =: ttInvitee[0].Meeting__c limit 1];
                if (ttMeeting.size()>0)
                {
                    ttMeeting[0].Scheduled__c = true;
                    ttMeeting[0].Confirmation_Number__c = appointment.confirmationNumber;
                    update ttMeeting[0];
                    newMeeting.Meeting__c = ttMeeting[0].Id;
                }

                List<Internal_Attendee__c> listOfInternalAttendees = new List<Internal_Attendee__c>();
                for(Id iterId: attendeeIDs){
                    listOfInternalAttendees.add(new Internal_Attendee__c(Invitation__c = ttActivity.Id, Name__c = iterId, Organizer__c = false, Meeting__c =ttMeeting[0].Id ));
                }       
                if(!listOfInternalAttendees.isEmpty()){
                    insert listOfInternalAttendees;
                }   
            }

                          
            
            
            //Start populating the event object
            newMeeting.OwnerId = selectedResource1;
            newmeeting.Invitation__c = ttActivity.Id;
            newMeeting.Subject = MeetingName;
            newMeeting.StartDateTime = dtSelectedTime;
            newMeeting.EndDateTime = dtSelectedTime.addMinutes(monthSlots[0].lengthinMin);
            newMeeting.ReminderDateTime = dtSelectedTime.addMinutes(-15);
            newMeeting.Location = MeetingLocation;
            newMeeting.Confirmation_Number__c = appointment.confirmationNumber;
            newMeeting.Conference_Provider__c = ttActivity.Web_Conference__c;
            newMeeting.Conference_Secret__c = WebConferencePassword;
            if(custAttendeeList != '' || custAttendeeList != null)
                newMeeting.Additional_Contacts__c = custAttendeeList;
            
            //Insert the meeting
            insert newMeeting;
            
            if(ttActivity.web_conference__c == null){
                //Lastly, send the confirmation email if selected and not using Web Conferencing
                if (ttNotifTemplate != null && ttNotifTemplate.Send_Confirmation_Email__c)
                {
                   newMeeting.Trigger_Confirmation_Email__c = true;
                   update newMeeting;
                }
            }
                   
            
        }
      /*  catch(DMLException ex) {
                        
            showErrorSection = true;
            errorTitle = 'Error Scheduling Meeting';
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            errorDescription = ex.getDMLMessage(0);
            
            database.rollback(sp);
            
            if(appointment.confirmationNumber!=null)    
                AsyncCallOutHelper.futureCancelMeeting(appointment.confirmationNumber);   
            return null;
        }*/
        catch(System.Exception ex) {
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

            showErrorSection = true;
            errorTitle = 'Error Scheduling Meeting';
            errorSubTitle = 'On Line: ' + ex.getLineNumber();
            errorDescription = ex.getMessage();
            database.rollback(sp);
            
            if(appointment.confirmationNumber!=null)    
                AsyncCallOutHelper.futureCancelMeeting(appointment.confirmationNumber);  
            return null;
        }
        
        //Show Confirmation Page
        PageReference pageRef;
        if(string.isBlank(TTLinkalatorSettings.Namespace_Prefix__c)){
            pageRef = new PageReference(TTLinkalatorSettings.CTS_Site_URL__c+'/MeetingStatus?Id=' + newMeeting.Id + '&timeZone=' +timeZoneName+'&BookNow=true');
            pageRef.setRedirect(true);
            
        }
        else if(!string.isBlank(TTLinkalatorSettings.Namespace_Prefix__c)){
            pageRef = new PageReference(TTLinkalatorSettings.CTS_Site_URL__c+'/TimeTrade_SF1__MeetingStatus?Id=' + newMeeting.Id + '&timeZone=' +timeZoneName+'&BookNow=true');
            pageRef.setRedirect(true);
            
        }
        return pageRef;
    }
   
    public boolean validateForm()
    {
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        if (String.isBlank(MeetingName) || attendeeList == null || attendeeList.size() < 1 || String.isBlank(strSlotType) || String.isBlank(selectedResource1) || selectedDay == 0 || selectedTime == 0 )
        {
            showErrorSection = true;
            errorTitle = 'Missing Information';
            errorSubTitle = 'Some required information is missing';
            errorDescription = System.Label.Book_Now_Invalid_Information_or_Invalid_Slot;
            hardError = false;
            return false;
        }
        
        
        return true;
    }
    
    public void hideError()
    {
        showErrorSection = false;
    }
public static boolean hasSObjectField(List<String> fieldList, String objName){
     Boolean noError=true;
       SObject sobj = Schema.getGlobalDescribe().get(objName).newSObject();
       try {
            for(String fieldName:fieldList) {
           system.debug('INSIDE FIELD NAME ---'+fieldName);
           
           return sobj.getSobjectType().getDescribe().fields.getMap().containsKey(fieldName);
                 
           }
       }
       catch(exception ex) {
           
       }
             
       
      
       return false;
}
   
}