@isTest
public class TestCtrl_CreateMeetingInvitationTemplate {
    public static TestMethod void testMethod1() {
        
        Date dToday = System.Today();
        Lead testLead=new Lead(LastName='Test Lead',Company='Test Company',Status='Open - Not Contacted');
        insert testLead;
        //Create Meeting Invitation Template
        Invitation_Template__c invTemplate = new Invitation_Template__c();
        /*invTemplate.name = 'Test Template';
        invTemplate.Invitation_Template__c = 'This is a Test Template';
        insert invTemplate;*/
        
        PageReference pageRef = Page.CreateMeetingInvitationTemplate;        
        test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(invTemplate);
        Ctrl_CreateMeetingInvitationTemplate controller = new Ctrl_CreateMeetingInvitationTemplate(sc);
        controller.InvitationTemplate= 'Test';
        controller.ConfirmationTemplate= 'Test';
        controller.ModificationTemplate= 'Test';
        controller.CancelTemplate= 'Test';
        controller.CompletionTemplate= 'Test';
        controller.NoShowTemplate= 'Test';
        controller.ReminderTemplate= 'Test';  
        controller.saverec();
        controller.saveandnew();
        controller.cancelrec(); 
    }
	public static TestMethod void testMethod2() {
        
        Date dToday = System.Today();
        Lead testLead=new Lead(LastName='Test Lead',Company='Test Company',Status='Open - Not Contacted');
        insert testLead;
        //Create Meeting Invitation Template
        Invitation_Template__c invTemplate = new Invitation_Template__c();
        
        PageReference pageRef = Page.CreateMeetingInvitationTemplate;        
        test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(invTemplate);
        Ctrl_CreateMeetingInvitationTemplate controller = new Ctrl_CreateMeetingInvitationTemplate(sc);
        controller.InvitationTemplate= 'Test';
        controller.ConfirmationTemplate= 'Test';
        controller.ModificationTemplate= 'Test';
        controller.CancelTemplate= 'Test';
        controller.CompletionTemplate= 'Test';
        controller.NoShowTemplate= 'Test';
        controller.ReminderTemplate= 'Test';  

        controller.isException = true;
        controller.saverec();
    }
}