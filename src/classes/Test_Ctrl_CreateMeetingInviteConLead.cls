@isTest
private class Test_Ctrl_CreateMeetingInviteConLead {
    
    static Customer_Attendee__c testCA = new Customer_Attendee__c(); 
    static Invitation__c testInv = new Invitation__c();
    static Invitation_Template__c testInvTemp = new Invitation_Template__c();
    static Contact testCon = new Contact();
    static Lead testLead = new Lead();
    static Map<String,Id> MapOfRTIDToRTName = new Map<String,Id>();
    
    static {
        testInvTemp.Name = 'Test Inv Temp';
        testInvTemp.Invitation_Template__c = 'TTMeeting_Invitation_Callout';
        insert testInvTemp;
        
        Date dt = date.today();
        testInv.Name = 'Test Invitation';
        testInv.Availability_Start__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 9, 0, 0);
        testInv.Availability_End__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 10, 0, 0);
        testInv.Duration__c = '30 Minutes';
        testInv.Template__c = testInvTemp.id;
        insert testInv;
        
        testCon.lastName = 'Test';
        insert testCon;
        
        testLead.lastName = 'Test';
        testLead.company = 'Test C';
        testLead.Status = 'Working - Contacted';
        insert testLead;
        
        for(RecordType RT:[select id,sobjecttype,developername  from recordtype where sobjecttype='Customer_Attendee__c']) {
             MapOfRTIDToRTName.put(RT.developername,RT.id);
         }
    }
    
    static testMethod void myUnitTest1() {        
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(testCA);   
        ApexPages.currentPage().getParameters().put('MIid',testInv.id);  
        Ctrl_CreateMeetingInviteConLead CCMICL = new Ctrl_CreateMeetingInviteConLead(sc);
        CCMICL.getrectypes();
        CCMICL.cntofli = 3;
        CCMICL.addmorelineitems();
        CCMICL.cntofli = 1003;
        CCMICL.addmorelineitems();
        CCMICL.SaveandRedirect();
        
        CCMICL.selectedRT = 'Lead_Related';
        
        Customer_Attendee__c tempCA = new Customer_Attendee__c();
        tempCA.Lead__c = testLead.id;
        CCMICL.MICList.add(tempCA);
        CCMICL.SaveandRedirect();
        CCMICL.selectedRT = 'Contact_Related';
        
        tempCA = new Customer_Attendee__c();
        tempCA.contact__c = testCon.id;
        CCMICL.MICList = new list<Customer_Attendee__c>();
        CCMICL.MICList.add(tempCA);
        CCMICL.SaveandRedirect();
        
        CCMICL.cancel(); 
                
        Invitation__c testInv2 = new Invitation__c();
        Date dt = date.today();
        testInv2.Name = 'Test Invitation 2';
        testInv2.Availability_Start__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 9, 0, 0);
        testInv2.Availability_End__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 10, 0, 0);
        testInv2.Duration__c = '30 Minutes';
        testInv2.Template__c = testInvTemp.id;
        insert testInv2;
        
        
        
        Meeting__c meeting = testDataDump.createMeeting(testInv2.ID);
        
        Customer_Attendee__c tempCA2 = new Customer_Attendee__c();     
        //tempCA2.RecordTypeId=MapOfRTIDToRTName.get('Contact_Related');
        tempCA2.Invitation__c = testInv2.id;  
        tempCA2.contact__c = testCon.id;
        tempCA2.Meeting__c = meeting.id;
        insert tempCA2;
        
        
        
        
        Customer_Attendee__c tempCA3 = new Customer_Attendee__c();    
        tempCA3.RecordTypeId=MapOfRTIDToRTName.get('Contact_Related'); 
        tempCA3.Invitation__c = testInv2.id;  
        try
        {
            insert tempCA3;
        }
        catch(exception e)
        {
            
        }
       
    }
    
    static testMethod void myUnitTest2() {        
        test.startTest();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(testCA);  
        ApexPages.currentPage().getParameters().put('MIid',testInv.id);  
        Ctrl_CreateMeetingInviteConLead CCMICL = new Ctrl_CreateMeetingInviteConLead(sc);
        CCMICL.selectedRT = 'Lead_Related';
        
        Customer_Attendee__c tempCA = new Customer_Attendee__c();
        tempCA.Lead__c = testLead.id;
        CCMICL.MICList.add(tempCA);
        CCMICL.MICList.add(tempCA);
        CCMICL.SaveandRedirect();
        CCMICL.selectedRT = 'Contact_Related';
        
        tempCA = new Customer_Attendee__c();
        tempCA.contact__c = testCon.id;
        CCMICL.MICList = new list<Customer_Attendee__c>();
        CCMICL.MICList.add(tempCA);
        CCMICL.MICList.add(tempCA);
        CCMICL.SaveandRedirect();        
        test.stopTest();
    }
    
    static testMethod void errorMethod() {
        Invitation__c testInvErr = new Invitation__c();
        Date dt = date.today();
        testInvErr.Name = 'Test Invitation 3';
        testInvErr.Availability_Start__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 9, 0, 0);
        testInvErr.Availability_End__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 10, 0, 0);
        testInvErr.Duration__c = '30 Minutes';
        testInvErr.Template__c = testInvTemp.id;
        insert testInvErr;
        Meeting__c meeting = testDataDump.createMeeting(testInvErr.ID);
        Customer_Attendee__c tempCAErr = new Customer_Attendee__c();     
       // tempCAErr.RecordTypeId=MapOfRTIDToRTName.get('Contact_Related');
        tempCAErr.Invitation__c = testInvErr.id;  
        tempCAErr.contact__c = testCon.id;
        tempCAErr.Who_ID__c='testemail';
        TimeTradeCustomerAttendeeTriggerHandler Handler=new TimeTradeCustomerAttendeeTriggerHandler();
        Handler.isError=true; 
        tempCAErr.Meeting__c = meeting.id;
        insert tempCAErr;
    }
    
    static testMethod void leadMethod(){
        test.startTest();
        Date dt = date.today();
        Invitation__c testInv3 = new Invitation__c();
        testInv3.Name = 'Test Invitation 3';
        testInv3.Availability_Start__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 9, 0, 0);
        testInv3.Availability_End__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 10, 0, 0);
        testInv3.Duration__c = '30 Minutes';
        testInv3.Template__c = testInvTemp.id;
        insert testInv3;
        Meeting__c meeting = testDataDump.createMeeting(testInv3.ID);
        Customer_Attendee__c tempCA4 = new Customer_Attendee__c();     
      //  tempCA4.RecordTypeId=MapOfRTIDToRTName.get('Lead_Related');
        tempCA4.Invitation__c = testInv3.id;  
        tempCA4.Lead__c = testLead.id;
        tempCA4.Meeting__c = meeting.id;
        insert tempCA4;
        
        Customer_Attendee__c tempCA5 = new Customer_Attendee__c();    
        tempCA5.RecordTypeId=MapOfRTIDToRTName.get('Lead_Related'); 
        tempCA5.Invitation__c = testInv3.id;  
        try
        {
            insert tempCA5;
        }
        catch(exception e)
        {
            
        }
        test.stopTest();
    }
        
}