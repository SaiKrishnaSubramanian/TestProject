@isTest
public class Test_BookNowController{
    
    public static testMethod void testBookNowController()
    {
        Contact firstContact = new Contact();
        firstContact.FirstName = 'Chris';
        firstContact.LastName = 'Gilmore';
        firstContact.Email = 'cgilmore@timetrade.com';
        insert firstContact;
        
               
        user PrimaryUser = [SELECT ID,Name,WebEx_User__c,WebEx_Password__c FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        update PrimaryUser;
        
        Invitation_Template__c invTemplate = new Invitation_Template__c();
        invTemplate.name = 'Test Template';
        invTemplate.Invitation_Template__c = 'This is a Test Template';
        insert invTemplate;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(firstContact);
        TimeTradeBookNowController objBookNowController = new TimeTradeBookNowController(sc);
      
        objBookNowController.selectedResource2 = UserInfo.getUserId();
        objBookNowController.searchTemplateTerm = 'test';
        objBookNowController.searchResource2Term = 'test';
        objBookNowController.searchResource3Term = 'test';
        objBookNowController.searchResource4Term = 'test';
        objBookNowController.searchResource5Term = 'test';
        objBookNowController.MeetingName = 'Test Meeting';
        objBookNowController.strSlotType = '30 Minutes';
        objBookNowController.selectedTemplate = 'TemplateName';
        objBookNowController.meetingInstructions = 'my notes';
        objBookNowController.strConfProvider = 'WebEx';
        objBookNowController.WebConferencePassword = 'mypassword';
        TimeTradeBookNowController.searchResource(PrimaryUser.Name);
        TimeTradeBookNowController.searchTemplate('Test');
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
        objBookNowController.setTimeZone();
        objBookNowController.prevMonth();
        objBookNowController.nextMonth();
    }
    public static testMethod void testBookNowController2()
    {
        Contact firstContact = new Contact();
        firstContact.FirstName = 'Chris';
        firstContact.LastName = 'Gilmore';
        firstContact.Email = 'cgilmore@timetrade.com';
        insert firstContact;
        
        Lead newlead=new Lead();
        newlead.FirstName='Test';
        newlead.LastName='Lead';
        newlead.LastName='test@test.com';
        newlead.Company='testcompany';
        insert newlead;
        
        user PrimaryUser = [SELECT ID,Name,WebEx_User__c,WebEx_Password__c FROM USER WHERE id=: UserInfo.getUserId() LIMIT 1];
        PrimaryUser.WebEx_User__c = 'testuser';
        PrimaryUser.WebEx_Password__c = 'testpass';
        update PrimaryUser;
        
        Invitation_Template__c invTemplate = new Invitation_Template__c();
        invTemplate.name = 'Test Template';
        invTemplate.Invitation_Template__c = 'This is a Test Template';
        insert invTemplate;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newlead);
        TimeTradeBookNowController objBookNowController = new TimeTradeBookNowController(sc);
      
        objBookNowController.selectedResource2 = UserInfo.getUserId();
        objBookNowController.timeZoneName='Asia/Calcutta';
        objBookNowController.searchTemplateTerm = 'test';
        objBookNowController.searchResource2Term = 'test';
        objBookNowController.searchResource3Term = 'test';
        objBookNowController.searchResource4Term = 'test';
        objBookNowController.searchResource5Term = 'test';
        objBookNowController.MeetingName = 'Test Meeting';
        objBookNowController.strSlotType = '30 Minutes';
        objBookNowController.selectedTemplate = 'TemplateName';
        objBookNowController.meetingInstructions = 'my notes';
        objBookNowController.strConfProvider = 'WebEx';
        objBookNowController.WebConferencePassword = 'mypassword';
        TimeTradeBookNowController.searchResource(PrimaryUser.Name);
        TimeTradeBookNowController.searchTemplate('Test');
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
        objBookNowController.setTimeZone();
        objBookNowController.prevMonth();
        objBookNowController.nextMonth();
    }
}