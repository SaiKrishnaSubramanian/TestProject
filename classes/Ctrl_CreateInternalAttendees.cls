/*
*   Test Class : Test_Ctrl_CreateInternalAttendees
*/
public with sharing class Ctrl_CreateInternalAttendees{
    public String MeetingInviteId;
    public string selectedRT{get;set;} 
    public Integer cntofli{get;set;}
    public list<Internal_Attendee__c> MICList{get;set;}
    public Internal_Attendee__c tempMIC;
    public Boolean FoundError{get;set;}
    public Ctrl_CreateInternalAttendees(ApexPages.StandardController stdController) 
    {
        FoundError=false;
        if(ApexPages.currentPage().getParameters().get('MIid')!=null)
        {           
            MeetingInviteId=ApexPages.currentPage().getParameters().get('MIid'); 
            
            MICList = new list<Internal_Attendee__c>();
            
            for(integer i=0;i<5;i++)
            {
                 tempMIC = new Internal_Attendee__c();
                 MICList.add(tempMIC);
            } 
        }
    }
    
    
    
    public void SaveandRedirect()
    {
        system.debug('**here to save');
        list<Internal_Attendee__c> MICListToInsert = new list<Internal_Attendee__c>();
        List<Meeting__c> ListOfMeetings = new List<Meeting__c>([select Id, Invitation__c from Meeting__c where Invitation__c =: MeetingInviteId]);    
        set<Id> setOfUsers = new set<Id>();
        system.debug('**selectedRT '+selectedRT);
        for(Internal_Attendee__c tmp : MICList)
            {
                if(tmp.Name__c != null && !setOfUsers.contains(tmp.Name__c))
                {
                    tmp.Invitation__c = Id.ValueOf(MeetingInviteId);
                    tmp.Meeting__c = ListOfMeetings[0].Id;
                    setOfUsers.add(tmp.Name__c);
                    MICListToInsert.add(tmp);
                }
                else if(tmp.Name__c != null && setOfUsers.contains(tmp.Name__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Internal_Attendee_Already_Present_In_A_Meeting));
                    FoundError=true;
                    return;
                }

            }   
        
        
        if(MICListToInsert != null && MICListToInsert.size() > 0)
        {
            try
            {
                FoundError=false;   
                insert MICListToInsert;
            }
            catch(exception ex)
            {
                ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

                system.debug('**Error while inserting the meeting invite contact/Lead records '+ex.getMessage());
               if(ex.getMessage().contains('duplicate'))
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Internal_Attendee_Already_Present_In_A_Meeting));
                else
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));

                FoundError=true;
            }
        }
        if(MICListToInsert.size()==0) {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Internal_Attendee_No_Attendee_Selected));
            FoundError=true;
        }
    }
    public PageReference Cancel()
    {
        return new PageReference('javascript:window.close()');
    }
    
    public void addmorelineitems()
    {
        Integer val = cntofli+MICList.size();
        if(cntofli > 1000 || val > 1000 )
        {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot add more than 1000 rows'));
         FoundError=true;
         return;
        }
        for(Integer i = 0; i < cntofli; i++)
        {
            tempMIC = new Internal_Attendee__c();
            MICList.add(tempMIC);
        }
    }
}