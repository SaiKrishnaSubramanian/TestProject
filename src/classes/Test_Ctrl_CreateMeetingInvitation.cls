@isTest
public class Test_Ctrl_CreateMeetingInvitation {
    public static TestMethod void testMethod1() {
        
        Date dToday = System.Today();
        Lead testLead=new Lead(LastName='Test Lead',Company='Test Company',Status='Open - Not Contacted');
        insert testLead;
        //Create Meeting Invitation Template
        Invitation_Template__c invTemplate = new Invitation_Template__c();
        invTemplate.name = 'Test Template';
        invTemplate.Invitation_Template__c = 'This is a Test Template';
        insert invTemplate;
		    
        PageReference pageRef = Page.CreateMeetingInvitation;        
        ApexPages.currentPage().getParameters().put('relId', testLead.Id);
        test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        Ctrl_CreateMeetingInvitation controller = new Ctrl_CreateMeetingInvitation(sc);
        controller.meetingInvitation.Name = 'Schedule DEBUG TEST';
        controller.meetingInvitation.Availability_Start__c = DateTime.now();
        controller.meetingInvitation.Availability_End__c = DateTime.now().AddDays(40);
        controller.meetingInvitation.Location__c = 'Virtual TEST Location';
        controller.meetingInvitation.Criteria__c = 'Ad-Hoc Meeting';
        controller.meetingInvitation.Duration__c = '60min All Day';
        controller.meetingInvitation.Private__c = true;
        controller.meetingInvitation.Template__c = invTemplate.Id;
        controller.Save();
        controller.saveandnew();
        controller.cancelrec(); 

        controller.isException = true;
        controller.Save();
    }
}