@isTest
private class Test_Ctrl_MeetingStatus {
    
    @isTest static void testCtrlMeetingStatus() {
        // Implement test code
        //Insert Contact
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.email = 'abc@gmail.com';
        con.Phone = '9865312575';
        insert con;

        //Update running user
        user PrimaryUser = [SELECT ID FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        update PrimaryUser;

        //Create Meeting Invitation Template
        Invitation_Template__c invTemplate = new Invitation_Template__c();
        invTemplate.name = 'Test Template';
        invTemplate.Invitation_Template__c = 'This is a Test Template';
        insert invTemplate;
        
        //Insert Meeting Invitation
        Invitation__c ttMeetingInvitation = new Invitation__c();
        ttMeetingInvitation.Name = 'Schedule DEBUG TEST';
        ttMeetingInvitation.Availability_Start__c = DateTime.now();
        ttMeetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        ttMeetingInvitation.Location__c = 'Virtual TEST Location';
        //ttMeetingInvitation.Criteria__c = 'Ad-Hoc Meeting';
        ttMeetingInvitation.Duration__c = '30 Minutes';
        ttMeetingInvitation.Private__c = true;
        ttMeetingInvitation.Template__c = invTemplate.Id;
        ttMeetingInvitation.OwnerId = UserInfo.getUserId();
        ttMeetingInvitation.Who_ID__c = con.Id;
        insert ttMeetingInvitation;

        Event ttMeetingEvent = new Event();
        ttMeetingEvent.OwnerId = UserInfo.getUserId();
        ttMeetingEvent.WhoId = con.id;
        ttMeetingEvent.Invitation__c = ttMeetingInvitation.Id;
        ttMeetingEvent.StartDateTime = dateTime.now();
        ttMeetingEvent.EndDateTime = datetime.now().addhours(1);
        ttMeetingEvent.Confirmation_Number__c = 'NBX1234';
        insert ttMeetingEvent;

        ApexPages.currentPage().getParameters().put('Id',ttMeetingEvent.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(ttMeetingEvent);
        Ctrl_MeetingStatus objCTSController = new Ctrl_MeetingStatus(ttMeetingEvent);
        objCTSController.selectedTimeZone = 'America/New_York';
        objCTSController.pageLoad();
        objCTSController.rescheduleAppointment();
        objCTSController.cancelAppointment();
        objCTSController.EvntID = ttMeetingEvent.Id;
        objCTSController.showWebConfDetails();
        Ctrl_MeetingStatus objCTSController1 = new Ctrl_MeetingStatus(new ApexPages.StandardController(ttMeetingEvent));
        objCTSController1.hideError();
    }
    
    

    
}