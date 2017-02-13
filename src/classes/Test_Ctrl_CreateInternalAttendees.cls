@isTest
private class Test_Ctrl_CreateInternalAttendees {
    
    static Customer_Attendee__c testCA = new Customer_Attendee__c(); 
    static Invitation__c testInv = new Invitation__c();
    static Invitation_Template__c testInvTemp = new Invitation_Template__c();
    
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
    }
    
    static testMethod void myUnitTest1() {
        
        ApexPages.Standardcontroller scr = new ApexPages.Standardcontroller(testCA);      
        ApexPages.currentPage().getParameters().put('MIid',testInv.id);  
        Ctrl_CreateInternalAttendees CCIA = new Ctrl_CreateInternalAttendees(scr);
        CCIA.cntofli = 3;
        CCIA.addmorelineitems();
        CCIA.cntofli = 1003;
        CCIA.addmorelineitems();
        CCIA.SaveandRedirect();        
        
        Internal_Attendee__c tempIA = new Internal_Attendee__c();
        tempIA.Name__c = UserInfo.getUserId();
        CCIA.MICList.add(tempIA);
        CCIA.SaveandRedirect();
        
        CCIA.cancel();
        
        Invitation__c testInv2 = new Invitation__c();
        Date dt = date.today();
        testInv2.Name = 'Test Invitation';
        testInv2.Availability_Start__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 9, 0, 0);
        testInv2.Availability_End__c = DateTime.newInstance(dt.year(), dt.month(), dt.day(), 10, 0, 0);
        testInv2.Duration__c = '30 Minutes';
        testInv2.Template__c = testInvTemp.id;
        insert testInv2;
        
        Meeting__c meeting = testDataDump.createMeeting(testInv2.ID);
        
        Internal_Attendee__c tempIA2 = new Internal_Attendee__c();
        tempIA2.Invitation__c = testInv2.id;
        tempIA2.Meeting__c = meeting.id;
        insert tempIA2;
        tempIA2.Organizer__c = true;
        try{
            update tempIA2;
        }
        catch(Exception e)
        {
            
        }
        tempIA2.Organizer__c = false;
        try{
            update tempIA2;
        }
        catch(Exception e)
        {
            
        }        
        Internal_Attendee__c tempIA3 = new Internal_Attendee__c();
        tempIA3.Invitation__c = testInv2.id;
        tempIA3.Organizer__c = true;
        try
        {
            insert tempIA3; 
        }
        catch(exception e)
        {
            
        }
        try{
            delete tempIA2;
        }
        catch(Exception e)
        {
            
        }        
    }
    
    static testMethod void myUnitTest2() {
        
        ApexPages.Standardcontroller scr = new ApexPages.Standardcontroller(testCA);      
        ApexPages.currentPage().getParameters().put('MIid',testInv.id);  
        Ctrl_CreateInternalAttendees CCIA = new Ctrl_CreateInternalAttendees(scr);
        Internal_Attendee__c tempIA = new Internal_Attendee__c();
        tempIA.Name__c = UserInfo.getUserId();
        CCIA.MICList.add(tempIA);
        CCIA.MICList.add(tempIA);
        CCIA.SaveandRedirect();
        
    }
}