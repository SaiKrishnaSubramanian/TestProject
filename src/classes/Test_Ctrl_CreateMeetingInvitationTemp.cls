@isTest(seeAllData=true)
public class Test_Ctrl_CreateMeetingInvitationTemp {
    public static TestMethod void testMethod1() { 
    
    Invitation_Template__c testTemp=new Invitation_Template__c();
        PageReference pageRef = Page.CreateMeetingInvitationTemplate;  
        test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(testTemp);
        Ctrl_CreateMeetingInvitationTemplate Ctlr=new Ctrl_CreateMeetingInvitationTemplate(sc);
        
    }
}