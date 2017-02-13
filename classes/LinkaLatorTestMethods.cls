@isTest
public class LinkaLatorTestMethods {

    public class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof TTAppointmentWS.bookAppointment_element)
                response.put('response_x', new TTAppointmentWS.bookAppointmentResponse());
            
            if(request instanceof TTAppointmentWS.cancelAppointment_element)
                response.put('response_x', new TTAppointmentWS.cancelAppointmentResponse());
            
            if(request instanceof TTAppointmentWS.getAppointmentByConfirmationNumber_element)
                response.put('response_x', new TTAppointmentWS.getAppointmentByConfirmationNumberResponse_element());
            
            if(request instanceof TTAppointmentWS.getAvailableNDateTimeSlotsStartFromDate)
                response.put('response_x', new TTAppointmentWS.getAvailableNDateTimeSlotsStartFromDateResponse());
            
            if(request instanceof TTAppointmentWS.updateAppointment_element)
                response.put('response_x', new TTAppointmentWS.updateAppointmentResponse());
            
            if(request instanceof TTAppointmentWS.rescheduleAppointment)
                response.put('response_x', new TTAppointmentWS.rescheduleAppointmentResponse());
            
            if(request instanceof TTAppointmentWS.setAppointmentLifeCycleState)
                response.put('response_x', new TTAppointmentWS.setAppointmentLifeCycleStateResponse());
            
            if(request instanceof TTClientServices.updateInsertClient_element)
                response.put('response_x', new TTClientServices.updateInsertClientResponse_element());
            
            if(request instanceof TTConfigurationWS.copyResourceDeep)
                response.put('response_x', new TTConfigurationWS.copyResourceDeepResponse());
            
            if(request instanceof TTConfigurationWS.updateInsertResource)
                response.put('response_x', new TTConfigurationWS.updateInsertResourceResponse());
            
            if(request instanceof TTConfigurationWS.getResourceByExternalId)
                response.put('response_x', new TTConfigurationWS.getResourceByExternalIdResponse());
            
            return;
        }
    }
    
    static testmethod void TTAppointmentWSTest()
    {
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        TTAppointmentWS.AppointmentWS myWS = new TTAppointmentWS.AppointmentWS();
        myWS.SetSecurity('test', 'test');
        myWS.getAvailableNDateTimeSlotsStartFromDate(new TTAppointmentWS.appointmentCriteria(), datetime.now(), datetime.now(), 50);
        myWS.cancelAppointment('w00t');
        //myWS.bookAppointment(null, null, null);
        myWS.setAppointmentLifeCycleState(new TTAppointmentWS.appointmentLifeCycleStateChange(), 'w00t');
        myWS.getAppointmentByConfirmationNumber('w00t');
        myWS.rescheduleAppointment('w00t', datetime.now());
        myWS.updateAppointment(new TTAppointmentServices.appointment());
        
        TTClientServices.ClientWS myCS = new TTClientServices.ClientWS();
        myCS.SetSecurity('test', 'test');
        myCS.updateInsertClient(new TTClientServices.client(), datetime.now());
        
        TTConfigurationWS.ConfigurationWS myConfS = new TTConfigurationWS.ConfigurationWS();
        myConfS.SetSecurity('test', 'test');
        myConfS.copyResourceDeep('test','test','test','test');
        myConfS.updateInsertResource(new TTConfigurationServices.resource());
        myConfS.getResourceByExternalId('test', 'test');
        
        
        //Do the types
        new TTApptConfiguration.resource();
        new TTApptConfiguration.secondaryResourceInfo();
        
        new TTAppointmentWS.address();
        new TTAppointmentWS.appointmentAnswer();
        new TTAppointmentWS.appointmentByConfirmationNumberStatus();
        new TTAppointmentWS.appointmentCriteria();
        new TTAppointmentWS.appointmentFullfilmentInfo();
        new TTAppointmentWS.appointmentLifeCycleStateChange();
        new TTAppointmentWS.appointmentLifeCycleStateInfo();
        new TTAppointmentWS.characteristic();
        new TTAppointmentWS.client();
        new TTAppointmentWS.dateSlot();
        new TTAppointmentWS.dateTimeSlot();
        new TTAppointmentWS.disposition();
        new TTAppointmentWS.emailAddressData();
        new TTAppointmentWS.option();
        new TTAppointmentWS.owner();
        new TTAppointmentWS.phoneData();
        new TTAppointmentWS.question();
        new TTAppointmentWS.resourcepool();
        new TTAppointmentWS.secondaryResourcePool();
        new TTAppointmentWS.TTServiceExceptn();
        new TTAppointmentWS.TTStatus();
        
        new TTClientServices.address();
        new TTClientServices.client();
        new TTClientServices.clientSearchCriteria();
        new TTClientServices.phoneData();
        new TTClientServices.TTExceptionService();
        new TTClientServices.TTStatus();
        
        
        new TTConfigurationServices.activity();
        new TTConfigurationServices.location();
        new TTConfigurationServices.resource();
        new TTConfigurationServices.schedule();
        new TTConfigurationWS.activityDuration();
        new TTConfigurationWS.activityRules();
        new TTConfigurationWS.address();
        new TTConfigurationWS.ConfigurationWS();
        new TTConfigurationWS.copyResourceDeep();
        new TTConfigurationWS.copyResourceDeepResponse();
        new TTConfigurationWS.emailAddressData();
        new TTConfigurationWS.geoCoordinates();
        new TTConfigurationWS.getResourceByExternalId();
        new TTConfigurationWS.getResourceByExternalIdResponse();
        new TTConfigurationWS.monthlySubSchedule();
        new TTConfigurationWS.monthlySubSchedulePeriod();
        new TTConfigurationWS.oneTimeSubSchedule();
        new TTConfigurationWS.oneTimeSubSchedulePeriod();
        new TTConfigurationWS.phoneData();
        new TTConfigurationWS.resourceRules();
        new TTConfigurationWS.suppressVisibilityPerApp();
        new TTConfigurationWS.TTStatus();
        new TTConfigurationWS.updateInsertResource();
        new TTConfigurationWS.updateInsertResourceResponse();
        new TTConfigurationWS.weeklySubSchedule();
        new TTConfigurationWS.weeklySubSchedulePeriod();
        new TTConfigurationWS.yearlySubSchedule();
        new TTConfigurationWS.yearlySubSchedulePeriod();
        
    }
    
    static testMethod void testUpdateTimeTradeMeetingTrigger()
    {
        TTLinkalatorSettings__c ttlSetting = new TTLinkalatorSettings__c();
        ttlSetting.CTS_Site_URL__c = 'https://google.com';
        ttlSetting.Location_External_ID__c = 'vlocation';
        ttlSetting.Program_External_ID__c = 'li';
        ttlSetting.Template_Resource_ExternalID__c = 'Test';
        ttlSetting.WebEx_Site_Name__c = 'Timetrade';
        ttlSetting.Org_Name__c = 'TimeTrade1';
        insert ttlSetting;
        
        user PrimaryUser = [SELECT ID FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        PrimaryUser.Zoom_ID__c = 'testpass';
        update PrimaryUser;
        
        Contact firstContact = new Contact();
        firstContact.FirstName = 'Chris';
        firstContact.LastName = 'Gilmore';
        firstContact.Email = 'cgilmore@timetrade.com';
        insert firstContact;
        
        Invitation_Template__c notifTemplate = new Invitation_Template__c();
        notifTemplate.Name = 'test Template';
        notifTemplate.Send_Confirmation_Email__c = true;
        notifTemplate.Confirmation_Template_Unique_Name__c = 'TTMeeting_Confirmation';
        notifTemplate.Send_Modification_Email__c = true;
        notifTemplate.Modification_Template_Unique_Name__c = 'TTMeeting_Modification';
        //notifTemplate.Use_Outlook_Meeting_Invite__c = true;
        notifTemplate.Invitation_Template__c = 'TTMeeting_Invitation_Callout';
        insert notifTemplate;
        
        system.debug('starting Update Trigger test');
        Invitation__c ttMeetingInvitation = new Invitation__c();
        ttMeetingInvitation.Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation.Availability_Start__c = DateTime.now();
        ttMeetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation.Location__c = 'Virtual TEST Location';
        ttMeetingInvitation.Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation.Duration__c = '30 Minutes';
        ttMeetingInvitation.Private__c = true;
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        ttMeetingInvitation.OwnerId = UserInfo.getUserId();
        ttMeetingInvitation.Who_ID__c = firstContact.Id;
        ttMeetingInvitation.Web_Conference__c = 'WebEx';
        ttMeetingInvitation.Web_Conference_Password__c = 'WebEx';
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        insert ttMeetingInvitation;
        
        
        ttMeetingInvitation.Send_Email__c = true;
        update ttMeetingInvitation;
        
        Event ttEvent = new Event();
        ttEvent.Subject = ttMeetingInvitation.Name;
        ttEvent.Location = ttMeetingInvitation.Location__c;
        ttEvent.Meeting_Status__c = 'Scheduled';
        ttEvent.Confirmation_Number__c = 'NBX7B2MS';
        ttEvent.StartDateTime = datetime.now();
        ttEvent.EndDateTime = ttEvent.StartDateTime.addHours(1);
        ttEvent.OwnerId = UserInfo.getUserId();
        ttEvent.WhoId = firstContact.Id;
        ttEvent.Conference_Provider__c = 'WebEx';
        ttEvent.Conference_Number__c = '623456876';
        ttEvent.Invitation__c = ttMeetingInvitation.id;
        ttEvent.Description = 'test notes';
        system.debug('inserting event...');
        insert ttEvent;
        
        //Test.setMock(HttpCalloutMock.class, new WebServiceMockImpl());
        
        system.debug('All Items created, now testing the trigger...');
        ttEvent.StartDateTime = ttEvent.StartDateTime.addHours(1);
        ttEvent.EndDateTime = ttEvent.EndDateTime.addHours(1);
    update ttEvent;
        
        ttEvent.Meeting_Status__c = 'Completed';
        update ttEvent;
        
        ttEvent.Meeting_Status__c = 'Canceled';
        update ttEvent;
        
    }
    
    public static testMethod void testSendEmailController(){
        TTLinkalatorSettings__c ttlSetting = new TTLinkalatorSettings__c();
        ttlSetting.CTS_Site_URL__c = 'https://google.com';
        ttlSetting.Location_External_ID__c = 'vlocation';
        ttlSetting.Program_External_ID__c = 'li';
        ttlSetting.Template_Resource_ExternalID__c = 'Test';
        ttlSetting.WebEx_Site_Name__c = 'Timetrade';
        ttlSetting.Org_Name__c = 'TimeTrade1';
        insert ttlSetting;
        
        user PrimaryUser = [SELECT ID FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        PrimaryUser.Zoom_ID__c = 'testpass';
        update PrimaryUser;
        
        Contact firstContact = new Contact();
        firstContact.FirstName = 'Chris';
        firstContact.LastName = 'Gilmore';
        firstContact.Email = 'cgilmore@timetrade.com';
        insert firstContact;
        
        Invitation_Template__c notifTemplate = new Invitation_Template__c();
        notifTemplate.Name = 'test Template';
        notifTemplate.Send_Confirmation_Email__c = true;
        notifTemplate.Confirmation_Template_Unique_Name__c = 'TTMeeting_Confirmation';
        notifTemplate.Send_Modification_Email__c = true;
        notifTemplate.Modification_Template_Unique_Name__c = 'TTMeeting_Modification';
        //notifTemplate.Use_Outlook_Meeting_Invite__c = true;
        notifTemplate.Invitation_Template__c = 'TTMeeting_Invitation_Callout';
        insert notifTemplate;
        
        system.debug('starting Update Trigger test');
        Invitation__c ttMeetingInvitation = new Invitation__c();
        ttMeetingInvitation.Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation.Availability_Start__c = DateTime.now();
        ttMeetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation.Location__c = 'Virtual TEST Location';
        ttMeetingInvitation.Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation.Duration__c = '30 Minutes';
        ttMeetingInvitation.Private__c = true;
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        ttMeetingInvitation.OwnerId = UserInfo.getUserId();
        ttMeetingInvitation.Who_ID__c = firstContact.Id;
        ttMeetingInvitation.Web_Conference__c = 'WebEx';
        ttMeetingInvitation.Web_Conference_Password__c = 'WebEx';
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        insert ttMeetingInvitation;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ttMeetingInvitation);
        LinkalatorVFcontroller controller1 = new LinkalatorVFcontroller(sc);
        controller1.CheckInternalAttendee();
        LinkalatorVFcontroller controller = new LinkalatorVFcontroller();
        string cancelPage = controller.cancel().getUrl();
        controller.myLinkalator = ttMeetingInvitation;
        controller.myLinkalator.Send_Email__c = true;
        controller.save();
    }

    public static testMethod void testCTSController(){
        TTLinkalatorSettings__c ttlSetting = new TTLinkalatorSettings__c();
        ttlSetting.CTS_Site_URL__c = 'https://google.com';
        ttlSetting.Location_External_ID__c = 'vlocation';
        ttlSetting.Program_External_ID__c = 'li';
        ttlSetting.Template_Resource_ExternalID__c = 'Test';
        ttlSetting.WebEx_Site_Name__c = 'Timetrade';
        ttlSetting.Org_Name__c = 'TimeTrade1';
        insert ttlSetting;
        
        system.debug('starting CTSController test');
        user PrimaryUser = [SELECT ID FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        PrimaryUser.Zoom_ID__c = 'testpass';
        update PrimaryUser;
        
        Contact firstContact = new Contact();
        firstContact.FirstName = 'Chris';
        firstContact.LastName = 'Gilmore';
        firstContact.Email = 'cgilmore@timetrade.com';
        insert firstContact;
        
        Invitation_Template__c notifTemplate = new Invitation_Template__c();
        
        notifTemplate.Name = 'test Template';
        notifTemplate.Send_Confirmation_Email__c = true;
        notifTemplate.Confirmation_Template_Unique_Name__c = 'TTMeeting_Confirmation';
        notifTemplate.Send_Modification_Email__c = true;
        notifTemplate.Modification_Template_Unique_Name__c = 'TTMeeting_Modification';
        //notifTemplate.Use_Outlook_Meeting_Invite__c = true;
        notifTemplate.Invitation_Template__c = 'TTMeeting_Invitation_Callout';
        insert notifTemplate;
        
        system.debug('starting Update Trigger test');
        Invitation__c ttMeetingInvitation = new Invitation__c();
        ttMeetingInvitation.Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation.Availability_Start__c = DateTime.now();
        ttMeetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation.Location__c = 'Virtual TEST Location';
        ttMeetingInvitation.Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation.Duration__c = '30 Minutes';
        ttMeetingInvitation.Private__c = true;
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        ttMeetingInvitation.OwnerId = UserInfo.getUserId();
        ttMeetingInvitation.Who_ID__c = firstContact.Id;
        ttMeetingInvitation.Web_Conference__c = 'WebEx';
        ttMeetingInvitation.Web_Conference_Password__c = 'WebEx';
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        insert ttMeetingInvitation;
        
        Invitation__c ttMeetingInvitation2 = new Invitation__c();
        ttMeetingInvitation2.Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation2.Availability_Start__c = DateTime.now();
        ttMeetingInvitation2.Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation2.Location__c = 'Virtual TEST Location';
        ttMeetingInvitation2.Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation2.Duration__c = '30 Minutes';
        ttMeetingInvitation2.Private__c = true;
        ttMeetingInvitation2.Template__c = notifTemplate.Id;
        ttMeetingInvitation2.OwnerId = UserInfo.getUserId();
        ttMeetingInvitation2.Who_ID__c = firstContact.Id;      
        ttMeetingInvitation2.Template__c = notifTemplate.Id;
        insert ttMeetingInvitation2;
        
        Invitation__c ttMeetingInvitation3 = new Invitation__c();
        ttMeetingInvitation3 .Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation3 .Availability_Start__c = DateTime.now();
        ttMeetingInvitation3 .Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation3 .Location__c = 'Virtual TEST Location';
        ttMeetingInvitation3 .Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation3 .Duration__c = '30 Minutes';
        ttMeetingInvitation3 .Private__c = false;
        ttMeetingInvitation3 .Template__c = notifTemplate.Id;
        ttMeetingInvitation3 .OwnerId = UserInfo.getUserId();
        ttMeetingInvitation3 .Who_ID__c = firstContact.Id;      
        ttMeetingInvitation3 .Template__c = notifTemplate.Id;
        ttMeetingInvitation3.scheduled__c=true;
        insert ttMeetingInvitation3 ;
        
        Meeting__c newMeeting=new Meeting__c();
        newMeeting.Invitation__c=ttMeetingInvitation.Id;
        insert newMeeting;
        Customer_Attendee__c custold=new Customer_Attendee__c();
        custold.Invitation__c=ttMeetingInvitation.Id;
        custold.Meeting__c=newMeeting.Id;
        custold.contact__c=firstcontact.Id;
        insert custold;
        Customer_Attendee__c cust = [select Id,Scheduled__c,ConfirmationNumber__c,contact__c  from Customer_Attendee__c where Invitation__c =:ttMeetingInvitation.Id];
        system.debug('All Items created, now going to VF page...');
        System.Test.setMock(WebServiceMock.class, new LinkaLatorTestMethods.WebServiceMockImpl());
        ApexPages.currentPage().getParameters().put('ttCustId',cust.Id);
        
        Ctrl_ClickToSchedule objCTSController = new Ctrl_ClickToSchedule(ttMeetingInvitation);
        objCTSController.ttActivity = null;
        objCTSController.pageLoad();
        
        objCTSController = new Ctrl_ClickToSchedule(ttMeetingInvitation);
        objCTSController.pageLoad();
        objCTSController.setTimeZone();
        objCTSController.hideError();


        
        cust.Scheduled__c = false;
        update cust;
        
        objCTSController = new Ctrl_ClickToSchedule(ttMeetingInvitation);
        objCTSController.pageLoad();
        ttMeetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        update ttMeetingInvitation;
        
        objCTSController = new Ctrl_ClickToSchedule(ttMeetingInvitation);
        objCTSController.timeZoneName='Asia/Calcutta';
        
        objCTSController.pageLoad();
        objCTSController.setTimeZone();
        objCTSController = new Ctrl_ClickToSchedule(ttMeetingInvitation);
        objCTSController.ttNotifTemplate = new Invitation_Template__c();
        string test2 = objCTSController.prevMonthClass;
        test2 = objCTSController.nextMonthClass;
        test2 = objCTSController.currentMonthTitle;
        test2= objCTSController.apptDurationTitle;
        if (objCTSController.formDisabled) test2 = '';
        objCTSController.pageLoad();
        objCTSController.setTZ();
        objCTSController.refreshMonthDays();
        objCTSController.nextMonth();
        objCTSController.prevMonth();
        
        objCTSController.monthSlots = new List<TTAppointmentWS.dateTimeSlot>();
        TTAppointmentWS.dateTimeSlot currentSlot = new TTAppointmentWS.dateTimeSlot();
        currentSlot.appointmentSlotTime = dateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        currentSlot.lengthinMin = 60;
        objCTSController.monthSlots.add(currentSlot);
        objCTSController.selectedDay = datetime.now().day();
        objCTSController.isBookable(datetime.now().day(), 1);
        
        objCTSController.selectDay();
        objCTSController.selectTime();
        //objCTSController.createWebex(DateTime.now(), 60);
        objCTSController.validateForm();
        objCTSController.selectedDay = 1;
        objCTSController.selectedTime = 60000;
        objCTSController.custFirstName = 'Chris';
        objCTSController.custLastName = 'Gilmore';
        objCTSController.custEmail = 'cgilmore@timetrade.com';
        objCTSController.dtselectedTime = datetime.now();
        objCTSController.custAttendeeList = 'cgilmore@timetrade.com,cg2@timetrade.com';
        objCTSController.bookAppointment();
        
        objCTSController.ttInvitee = null;
        objCTSController.bookAppointment();
        
        objCTSController.custEmail = 'abc123@timetrade.com';
        objCTSController.bookAppointment();
         
         objCTSController.rescheduleAppointment();
       // objCTSController.custEmail = 'abc123@timetrade.com';
        
       
        
        objCTSController = new Ctrl_ClickToSchedule(ttMeetingInvitation2);
        objCTSController.pageLoad();
         objCTSController.setTimeZone();
        objCTSController.hideError();
       
          cust.ConfirmationNumber__c='12345';
         test.startTest();
        Event eve=new Event();
        eve.whoId=cust.contact__c;
        eve.Confirmation_Number__c= cust.ConfirmationNumber__c;
        eve.DurationInMinutes=60;
        eve.ActivityDateTime=system.now();
        eve.Invitation__c=ttMeetingInvitation3.Id;
        insert eve;
         objCTSController = new Ctrl_ClickToSchedule(ttMeetingInvitation2);
         objCTSController.pageLoad();
          test.stopTest();

    } 
    
    public static testMethod void testApptStatusController()
    {
        TTLinkalatorSettings__c ttlSetting = new TTLinkalatorSettings__c();
        ttlSetting.CTS_Site_URL__c = 'https://google.com';
        ttlSetting.Location_External_ID__c = 'vlocation';
        ttlSetting.Program_External_ID__c = 'li';
        ttlSetting.Template_Resource_ExternalID__c = 'Test';
        ttlSetting.WebEx_Site_Name__c = 'Timetrade';
        ttlSetting.Org_Name__c = 'TimeTrade1';
        insert ttlSetting;
        
        system.debug('starting ApptStatusController test');
        user PrimaryUser = [SELECT ID FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        PrimaryUser.Zoom_ID__c = 'testpass';
        update PrimaryUser;
        
        Contact firstContact = new Contact();
        firstContact.FirstName = 'Chris';
        firstContact.LastName = 'Gilmore';
        firstContact.Email = 'cgilmore@timetrade.com';
        insert firstContact;
        
        Invitation_Template__c notifTemplate = new Invitation_Template__c();
        notifTemplate.Name = 'test Template';
        notifTemplate.Send_Confirmation_Email__c = true;
        notifTemplate.Confirmation_Template_Unique_Name__c = 'TTMeeting_Confirmation';
        notifTemplate.Send_Modification_Email__c = true;
        notifTemplate.Modification_Template_Unique_Name__c = 'TTMeeting_Modification';
        //notifTemplate.Use_Outlook_Meeting_Invite__c = true;
        notifTemplate.Invitation_Template__c = 'TTMeeting_Invitation_Callout';
        insert notifTemplate;
        
        system.debug('starting Update Trigger test');
        Invitation__c ttMeetingInvitation = new Invitation__c();
        ttMeetingInvitation.Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation.Availability_Start__c = DateTime.now();
        ttMeetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation.Location__c = 'Virtual TEST Location';
        ttMeetingInvitation.Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation.Duration__c = '30 Minutes';
        ttMeetingInvitation.Private__c = true;
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        ttMeetingInvitation.OwnerId = UserInfo.getUserId();
        ttMeetingInvitation.Who_ID__c = firstContact.Id;
        ttMeetingInvitation.Web_Conference__c = 'WebEx';
        ttMeetingInvitation.Web_Conference_Password__c = 'WebEx';
        ttMeetingInvitation.Template__c = notifTemplate.Id;
        insert ttMeetingInvitation;
        
        
        Event ttMeetingEvent = new Event();
        ttMeetingEvent.OwnerId = UserInfo.getUserId();
        ttMeetingEvent.WhoId = firstContact.Id;
        ttMeetingEvent.Invitation__c = ttMeetingInvitation.Id;
        ttMeetingEvent.StartDateTime = dateTime.now();
        ttMeetingEvent.EndDateTime = datetime.now().addhours(1);
        ttMeetingEvent.Confirmation_Number__c = 'NBX1234';
        insert ttMeetingEvent;
        
        system.debug('All Items created, now going to VF page...');
        //ApexPages.currentPage().getParameters().put('ttCustId',ttInvitee.Id);
        Ctrl_MeetingStatus objStatusController = new Ctrl_MeetingStatus(ttMeetingEvent);
        objStatusController.ttEvent = null;
        objStatusController.appointment = new TTAppointmentServices.appointment();
        objStatusController.appointment.appointmentStartDate = dateTime.now();
        objStatusController.appointment.appointmentDurationMin = 60;
        objStatusController.appointment.resourceExternalId = UserInfo.getUserEmail();
        objStatusController.appointment.custom2 = 'test';
        objStatusController.quickAction = 'nothing';
        objStatusController.pageLoad();
        objStatusController.hideError();
        
        objStatusController = new Ctrl_MeetingStatus(ttMeetingEvent);
        objStatusController.pageLoad();
        
        
        objStatusController.rescheduleAppointment();
        
   }
    
    public static testMethod void testBookNowController()
    {
        Contact firstContact = new Contact();
        firstContact.FirstName = 'Chris';
        firstContact.LastName = 'Gilmore';
        firstContact.Email = 'cgilmore@timetrade.com';
        insert firstContact;
        
        user PrimaryUser = [SELECT ID FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        update PrimaryUser;
        
         ApexPages.StandardController sc = new ApexPages.StandardController(firstContact);
        TimeTradeBookNowController objBookNowController = new TimeTradeBookNowController(sc);
        objBookNowController.selectedResource2 = UserInfo.getUserId();
        objBookNowController.searchTemplateTerm = 'test';
        objBookNowController.searchResource2Term = 'test';
        objBookNowController.searchResource3Term = 'test';
        objBookNowController.searchResource4Term = 'test';
        objBookNowController.searchResource5Term = 'test';
        objBookNowController.MeetingName = 'Test Meeting';
        objBookNowController.strSlotType = '60min All Day';
        objBookNowController.selectedTemplate = 'TemplateName';
        objBookNowController.meetingInstructions = 'my notes';
        objBookNowController.strConfProvider = 'WebEx';
        objBookNowController.WebConferencePassword = 'mypassword';
        objBookNowController.pageLoad();
        objBookNowController.CriteriaChanged();
        objBookNowController.setTZ();
        objBookNowController.refreshMonthDays();
        objBookNowController.nextMonth();
        objBookNowController.prevMonth();
        
        objBookNowController.monthSlots = new List<TTAppointmentWS.dateTimeSlot>();
        TTAppointmentWS.dateTimeSlot currentSlot = new TTAppointmentWS.dateTimeSlot();
        currentSlot.appointmentSlotTime = dateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        currentSlot.lengthinMin = 60;
        objBookNowController.monthSlots.add(currentSlot);
        objBookNowController.selectedDay = datetime.now().day();
        
        objBookNowController.selectDay();
        objBookNowController.selectTime();
        objBookNowController.isBookable(datetime.now().day(), 1);
        
        objBookNowController.selectedDay = 1;
        objBookNowController.selectedTime = 60000;
        
        objBookNowController.dtselectedTime = datetime.now();
        objBookNowController.custAttendeeList = 'cgilmore@timetrade.com,cg2@timetrade.com';
        objBookNowController.bookAppointment();
        
        
    }
    
   
}