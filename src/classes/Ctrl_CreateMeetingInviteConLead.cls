/*
*	Test Class : Test_Ctrl_CreateMeetingInviteConLead
*/
public with sharing class Ctrl_CreateMeetingInviteConLead {
    public String MeetingInviteId;
    public string selectedRT{get;set;} 
    public Integer cntofli{get;set;}
    public list<Customer_Attendee__c> MICList{get;set;}
    public Customer_Attendee__c tempMIC;
    public Boolean FoundError{get;set;}
    public Map<String,ID> MapOfRTIDToRTName;
    public List<Invitation__c> Invite;
    TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();

    public Ctrl_CreateMeetingInviteConLead(ApexPages.StandardController stdController) 
    {

        
        MapOfRTIDToRTName=new Map<String,ID>();
        String sObj = '';
            if(String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = 'Customer_Attendee__c';
            else if(!String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = TTLinkalatorSettings.Namespace_Prefix__c + 'Customer_Attendee__c';
              
        for(RecordType RT:[select id,sobjecttype,developername  from recordtype where sobjecttype=:sObj]) {
                 MapOfRTIDToRTName.put(RT.developername,RT.id);
             }
        FoundError=false;

           
        if(ApexPages.currentPage().getParameters().get('MIid')!=null)
        {           
            MeetingInviteId=ApexPages.currentPage().getParameters().get('MIid'); 
			selectedRT = 'Contact_Related';
            MICList = new list<Customer_Attendee__c>();
            
            for(integer i=0;i<1;i++)
            {
                 tempMIC = new Customer_Attendee__c();
                 MICList.add(tempMIC);
            } 
            Invite=[SELECT Who_ID__c FROM Invitation__c WHERE ID=:MeetingInviteId LIMIT 1];
                     if(Invite[0].Who_ID__c!=null){                
                if(((ID)(Invite[0].Who_ID__c)).getSObjectType().getDescribe().getName()=='Contact')
            selectedRT = 'Contact_Related';
            else
            selectedRT = 'Lead_Related';    
           }      
        }
    }
    
    public List<SelectOption> getrectypes() {
        List<SelectOption> options = new List<SelectOption>();
        String sObj = '';
            if(String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = 'Customer_Attendee__c';
            else if(!String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = TTLinkalatorSettings.Namespace_Prefix__c + 'Customer_Attendee__c';
        for(RecordType rt:[select id,name,DeveloperName from RecordType where sobjecttype=: sObj]){
            options.add(new SelectOption(rt.DeveloperName,rt.name));   
        }
        
        return options;   
    } 
    
    public void SaveandRedirect()
    {

        Integer countOfAttendees = [select Count() from Customer_Attendee__c where Invitation__c =: MeetingInviteId];
        if(countOfAttendees > 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Beta version, only one Client Attendee can be added'));
            FoundError=true;
            return;
        }
        list<Customer_Attendee__c> MICListToInsert = new list<Customer_Attendee__c>();
        List<Meeting__c> ListOfMeetings = new List<Meeting__c>([select Id, Invitation__c from Meeting__c where Invitation__c =: MeetingInviteId]);    
        
        set<Id> setOfUsers = new set<Id>();
        if(selectedRT == 'Contact_Related')
        {
            for(Customer_Attendee__c tmp : MICList)
            {
                system.debug('contacttt '+tmp.Contact__c);
                system.debug('setOfUserssss '+setOfUsers);
                if(tmp.Contact__c != null && !setOfUsers.contains(tmp.Contact__c))
                {
                    tmp.Invitation__c = Id.ValueOf(MeetingInviteId);
                    tmp.Meeting__c = ListOfMeetings[0].Id;
                    tmp.RecordTypeId=MapOfRTIDToRTName.get(selectedRT);
                    tmp.Lead__c=null;
                    MICListToInsert.add(tmp);
                    setOfUsers.add(tmp.Contact__c);
                }
                else if(tmp.Contact__c != null && setOfUsers.contains(tmp.Contact__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Customer_Attendee_Already_Present_in_a_Meeting));
                    FoundError=true;
                    return;
                }
            }
        }
        else if(selectedRT == 'Lead_Related')
        {
            for(Customer_Attendee__c tmp : MICList)
            {
                if(tmp.Lead__c != null && !setOfUsers.contains(tmp.Lead__c))
                {
                    tmp.Invitation__c = Id.ValueOf(MeetingInviteId);
                    tmp.Meeting__c = ListOfMeetings[0].Id;
                    tmp.RecordTypeId=MapOfRTIDToRTName.get(selectedRT);
                    tmp.Contact__c=null;
                    MICListToInsert.add(tmp);
                    setOfUsers.add(tmp.Lead__c);
                }
                else if(tmp.Lead__c != null && setOfUsers.contains(tmp.Lead__c)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Customer_Attendee_Already_Present_in_a_Meeting));
                    FoundError=true;
                    return;
                }
            }
        }
        
        if(MICListToInsert != null && MICListToInsert.size() > 0)
        {
            try
            {

                system.debug('INSERTED LIST--'+MICListToInsert);
                FoundError=false;
                insert MICListToInsert;
                
            }

            catch(exception ex) {
            //Insert Debug Log object whenever there is an error
                FoundError=true;
                ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

             /*   Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();              
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Error_Message__c=ex.getMessage();
                Log.Exception_Type__c=ex.getTypeName();

                insert Log;*/
                 if(!ex.getMessage().contains('Lead')&&!ex.getMessage().contains('Contact'))
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
               
                    
                return ;
            }   







            

        }
        if(MICListToInsert.size()==0) {
            FoundError=true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Customer_Attendee_No_Attendee_Selected));
        }
    }
    public PageReference Cancel()
    {
        return new PageReference('javascript:window.close()');
    }
    
    public void addmorelineitems()
    {
    	system.debug('**MICList '+MICList);
        Integer val = cntofli+MICList.size();
        if(cntofli > 1000 || val > 1000 )
        {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot add more than 1000 rows'));
         return;
        }
        for(Integer i = 0; i < cntofli; i++)
        {
            tempMIC = new Customer_Attendee__c();
            MICList.add(tempMIC);
        }
    }
}