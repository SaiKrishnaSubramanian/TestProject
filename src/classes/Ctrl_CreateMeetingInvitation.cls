public with sharing class Ctrl_CreateMeetingInvitation {
    private ApexPages.StandardController stdController;
    public Invitation__c meetingInvitation {get;set;}
    public string UserName{get;set;}
    public boolean isException;
    private String ttCustomerID;
    
    public Ctrl_CreateMeetingInvitation(ApexPages.StandardController controller) {
        isException = false;
        this.stdController=controller; 
        meetingInvitation = new Invitation__c();
        UserName=UserInfo.getName();
        ttCustomerID = ApexPages.currentPage().getParameters().get('relId');
    }

    public PageReference Save() {
        try {
            if(meetingInvitation!= null){
                if(isException && Test.isRunningTest()){
                    Integer i = 1/0;
                }
                meetingInvitation.who_ID__c = ttCustomerID;
                insert meetingInvitation;
                PageReference pg = new PageReference('/'+meetingInvitation.Id);
                pg.setRedirect(true);
                return pg;
            }
            else{
                 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Meeting_Invitation_Error_In_Record_Creation));
                return null;
            }
        }
    /*    catch(DMLException ex) {
            //Insert Debug Log object whenever there is an error
                Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();              
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Error_Message__c=ex.getMessage();
                Log.Exception_Type__c=ex.getTypeName();
                insert Log;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getDMLMessage(0)));    
                
            return null;
        }*/
        catch(Exception ex) {
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

           /*     Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();              
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Error_Message__c=ex.getMessage();
                Log.Exception_Type__c=ex.getTypeName();
                insert Log;*/
            
            if(!(ex.getMessage().contains('WebEx')))
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));    
                
            return null;
        }
    }

    public PageReference saveandnew() {
        Save();
        
        PageReference redirectPage = Page.CreateMeetingInvitation;
        redirectPage.setRedirect(true);
        return redirectPage;
       
    }
    public PageReference cancelrec() {
        Schema.DescribeSObjectResult result = Invitation__c.SObjectType.getDescribe(); 
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix()+'/o'); 
        pageRef.setRedirect(true); 
        return pageRef; 
        
    }
}