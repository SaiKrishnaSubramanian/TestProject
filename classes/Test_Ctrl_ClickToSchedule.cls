@isTest(seeAllData=false)
public class Test_Ctrl_ClickToSchedule {
    
    public static TestMethod void testmethod1()  {
        Map<String,ID> MapOfRTIDToRTName=new Map<String,ID>();
        TTLinkalatorSettings__c TestCS=new TTLinkalatorSettings__c(Location_External_ID__c='vlocation',CTS_Site_URL__c='https://clicktoschedule-developer-edition.ap2.force.com/cts',
                                                                   Org_Name__c='TimeTrade1',Program_External_ID__c='li',Template_Resource_ExternalID__c='Test Ext ID');
        insert TestCS;
        for(RecordType RT:[select id,sobjecttype,developername  from recordtype where sobjecttype='Customer_Attendee__c']) {
                 MapOfRTIDToRTName.put(RT.developername,RT.id);
             }
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_Lister@testorg.com');
        Contact TestCon=new Contact(LastName='TestCon');
        insert TestCon;
        Lead TestLead=new Lead(Lastname='TestLead',company='Test Comp',Status='Open - Not Contacted');
        insert TestLead;
       Invitation_Template__c testTemp=new Invitation_Template__c(Name='Test Temp',Invitation_Template__c='Test Inv Temp');
        insert testTemp;
        
        Date dToday = System.Today();
        Invitation__c MeetingInv=new Invitation__c(Name='Test Meeting',Availability_Start__c=system.now(),
                                                     OwnerId=Userinfo.getUserId(),
                                                     Location__c='Test Location',
                                                     Private__c=true,
                                                     Availability_End__c=system.now().addDays(10),
                                                     Duration__c='30 Minutes',Template__c=testTemp.ID,Who_ID__c=TestLead.Id,Criteria__c='Ad-Hoc Meeting');
        system.runAs(u) {
            
        insert MeetingInv;
        }
        
        Meeting__c meeting = testDataDump.createMeeting(MeetingInv.ID);
        
        Internal_Attendee__c TestAttendee=new Internal_Attendee__c(Name__c=Userinfo.getUserId(),Invitation__c=MeetingInv.Id,Meeting__c = meeting.Id);
        insert TestAttendee;
       /* Event RelatedEvent=new Event(StartDateTime=MeetingInv.Availability_Start__c,Meeting_Status__c='Scheduled',Invitation__c=MeetingInv.ID,DurationInMinutes=60);
        insert RelatedEvent;*/
       
        Customer_Attendee__c  testCustomerold=new Customer_Attendee__c (Attendee_s_Name__c='test FN test LN',Attendee_Email__c='test@test.com',Lead__c=TestLead.ID,Type__c='Lead',Invitation__c=MeetingInv.Id,Meeting__c=meeting.Id);
       insert testCustomerold;
        Customer_Attendee__c  testCustomer=[SELECT ID,Attendee_s_Name__c,ConfirmationNumber__c,Lead__c FROM Customer_Attendee__c WHERE Invitation__c=:MeetingInv.Id];
        ApexPages.StandardController sc = new ApexPages.StandardController(MeetingInv);
        Ctrl_ClickToSchedule testCTSControl = new Ctrl_ClickToSchedule(sc);
                
        PageReference pageRef = Page.ClickToSchedule;
        pageRef.getParameters().put('id', String.valueOf(MeetingInv.Id));
        pageRef.getParameters().put('ttCustID',String.valueOf(testCustomer.Id));
        Test.setCurrentPage(pageRef);
       
        Test.setMock(WebServiceMock.class, new WebserviceMockResponse());
        testCTSControl.timeZoneName='Asia/Calcutta';   
        testCTSControl.selectedDay=Date.today().day();
        testCTSControl.pageload();
        testCTSControl.bookAppointment();
        testCTSControl.rescheduleAppointment();
        //
        Test.startTest();
        testCTSControl.setTZ();
        //testCTSControl.refreshMonthDays();
      //  testCTSControl.prevMonth();
      //  testCTSControl.nextMonth();
       // testCTSControl.selectDay();
        
        Test.stopTest();
    }
    
}