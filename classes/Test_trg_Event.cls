@isTest
private class Test_trg_Event {
    
    @isTest static void eventTrigger() {
        // Implement test code
        //Insert Contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.email = 'abc@gmail.com';
        con.Phone = '9865312575';
        insert con;

        //Update running user
        user PrimaryUser = [SELECT ID,WebEx_User__c,WebEx_Password__c,Zoom_ID__c FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        PrimaryUser.Zoom_ID__c = 'abcdef';
        update PrimaryUser;

        TTLinkalatorSettings__c ttlSetting = new TTLinkalatorSettings__c();
        ttlSetting.CTS_Site_URL__c = 'https://google.com';
        ttlSetting.Location_External_ID__c = 'vlocation';
        ttlSetting.Program_External_ID__c = 'li';
        ttlSetting.Template_Resource_ExternalID__c = 'Test';
        ttlSetting.WebEx_Site_Name__c = 'Timetrade';
        ttlSetting.Org_Name__c = 'TimeTrade1';
        insert ttlSetting;
        //Create Meeting Invitation Template
        Invitation_Template__c invTemplate = new Invitation_Template__c();
        invTemplate.name = 'Test Template';
        invTemplate.Invitation_Template__c = 'This is a Test Template';
        insert invTemplate;
        
        
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testTT.com',WebEx_User__c='testuser2',WebEx_Password__c = 'testpass');
        
            Invitation__c ttMeetingInvitation = new Invitation__c();
       
        //Insert Meeting Invitation
    
        ttMeetingInvitation.Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation.Availability_Start__c = DateTime.now();
        ttMeetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation.Location__c = 'Virtual TEST Location';
        //ttMeetingInvitation.Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation.Duration__c = '60 Minutes';
        ttMeetingInvitation.Private__c = true;
        ttMeetingInvitation.Template__c = invTemplate.Id;
        ttMeetingInvitation.OwnerId = UserInfo.getUserId();
        ttMeetingInvitation.Who_ID__c = con.Id;
        ttMeetingInvitation.Web_Conference__c = 'WebEx';
        ttMeetingInvitation.Web_Conference_Password__c = 'testpass';
        
        insert ttMeetingInvitation;
        Meeting__c meeting = testDataDump.createMeeting(ttMeetingInvitation.ID);
        
        System.runAs(u) {
        Internal_Attendee__c AttTwo=new Internal_Attendee__c();
        AttTwo.Name__c=Userinfo.getuserID();
        AttTwo.Invitation__c=ttMeetingInvitation.Id;
        AttTwo.Meeting__c=meeting.Id;

        insert AttTwo;
     }
            Event ttMeetingEvent = new Event();
        ttMeetingEvent.OwnerId = UserInfo.getUserId();
        ttMeetingEvent.WhoId = con.id;
        ttMeetingEvent.Invitation__c = ttMeetingInvitation.Id;
        ttMeetingEvent.StartDateTime = dateTime.now();
        ttMeetingEvent.EndDateTime = datetime.now().addhours(1);
        ttMeetingEvent.Confirmation_Number__c = 'NBX1234';
        ttMeetingEvent.Conference_Provider__c = 'WebEx';
        ttMeetingEvent.Subject = 'Test';
        ttMeetingEvent.Conference_Number__c = '123456';
        insert ttMeetingEvent;
            ttMeetingEvent.EndDateTime = datetime.now().addhours(2);
            ttMeetingEvent.Meeting_Status__c = 'Canceled';
       
              
        update ttMeetingEvent;     

        Event ttMeetingEvent1 = new Event();
        ttMeetingEvent1.OwnerId = UserInfo.getUserId();
        ttMeetingEvent1.WhoId = con.id;
        ttMeetingEvent1.Invitation__c = ttMeetingInvitation.Id;
        ttMeetingEvent1.StartDateTime = dateTime.now();
        ttMeetingEvent1.EndDateTime = datetime.now().addhours(1);
        ttMeetingEvent1.Confirmation_Number__c = 'NBX1234';
        ttMeetingEvent1.Conference_Provider__c = 'Zoom';
        ttMeetingEvent1.Subject = 'Test';
        ttMeetingEvent1.Conference_Number__c = '123456';
        ttMeetingEvent1.Additional_Contacts__c = 'aa@abc.com';
        insert ttMeetingEvent1;

        ttMeetingEvent1.EndDateTime = datetime.now().addhours(2);
        ttMeetingEvent1.Conference_Provider__c = 'WebEx';
        update ttMeetingEvent1;
        
        ttMeetingEvent1.Conference_Provider__c = '';
        update ttMeetingEvent1;
        
        ttMeetingEvent1.Conference_Provider__c = 'WebEx';
        update ttMeetingEvent1;
        
        ttMeetingEvent1.Conference_Provider__c = '';
        update ttMeetingEvent1;
        
        ttMeetingEvent1.Conference_Provider__c = 'Zoom';
        update ttMeetingEvent1;
        
        ttMeetingEvent1.Meeting_Status__c = 'Canceled';
        update ttMeetingEvent1;
        
          WebExHelper.CancelWebex(ttMeetingEvent1.Id,ttMeetingEvent1.Conference_Number__c,PrimaryUser .WebEx_User__c, PrimaryUser.WebEx_Password__c);
        
    }
    
    @isTest static void test_method_two() {
        TTConfigurationServices.activity TTC1 = new TTConfigurationServices.activity();
        TTConfigurationServices.location TTC2 = new TTConfigurationServices.location();
        TTConfigurationServices.resource TTC3 = new TTConfigurationServices.resource();
        TTConfigurationServices.schedule TTC4 =  new TTConfigurationServices.schedule();
        TTApptConfiguration.resource res = new TTApptConfiguration.resource();
        TTApptConfiguration.secondaryResourceInfo sec = new TTApptConfiguration.secondaryResourceInfo();
        TTClientServices.ClientWS client = new TTClientServices.ClientWS();
        TTClientServices.TTExceptionService except  = new TTClientServices.TTExceptionService();
        TTClientServices.TTStatus status = new TTClientServices.TTStatus();
        TTClientServices.address address = new TTClientServices.address();
        TTClientServices.client cl = new TTClientServices.client();
        TTClientServices.clientSearchCriteria  search = new TTClientServices.clientSearchCriteria();
        TTClientServices.phoneData phone = new TTClientServices.phoneData();
        TTClientServices.updateInsertClientResponse_element clientres = new TTClientServices.updateInsertClientResponse_element();
    }
    
}