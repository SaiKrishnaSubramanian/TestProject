public class TimeTradeCustomerAttendeeTriggerHandler {
    public Boolean IsError;
    public void PreventCreation(List<Customer_Attendee__c> TriggerNew,Boolean IsInsert) {
        IsError=false;
        Set<ID> MeetingInvIDs=new Set<ID>();
        Map<ID,ID> MapOfMeetingToRecordType=new Map<ID,ID>();
        Map<String,ID> MapOfRTIDToRTName=new Map<String,ID>();
        Map<Id,List<Customer_Attendee__c>> MapOfMeetingInvToCont=new Map<Id,List<Customer_Attendee__c>>();
        List<Customer_Attendee__c> MeetingInvContacts=new List<Customer_Attendee__c>();
        TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();

        String sObj = '';
            if(String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = 'Customer_Attendee__c';
            else if(!String.isBlank(TTLinkalatorSettings.Namespace_Prefix__c))
                sObj = TTLinkalatorSettings.Namespace_Prefix__c + 'Customer_Attendee__c';
        for(RecordType RT:[select id,sobjecttype,developername  from recordtype where sobjecttype=:sObj]) {
                 MapOfRTIDToRTName.put(RT.developername,RT.id);
             }
        for(Customer_Attendee__c CurrentContact:TriggerNew) {
            MeetingInvIDs.add(CurrentContact.Invitation__c);
                   }
        
        MeetingInvContacts=[SELECT ID,Contact__c,Lead__c,Type__c,Invitation__c,RecordTypeId,RecordType.Developername FROM Customer_Attendee__c WHERE Invitation__c IN:MeetingInvIDs];
        for(Customer_Attendee__c CurrentInvCon:MeetingInvContacts) {
            
            MapOfMeetingToRecordType.put(CurrentInvCon.Invitation__c,CurrentInvCon.RecordTypeId); 
            if(MapOfMeetingInvToCont.containsKey(CurrentInvCon.Invitation__c)) {
                MapOfMeetingInvToCont.get(CurrentInvCon.Invitation__c).add(CurrentInvCon);
            }
            else {
                MapOfMeetingInvToCont.put(CurrentInvCon.Invitation__c,new list<Customer_Attendee__c>{CurrentInvCon});
            }
                }
      
           
              for(Customer_Attendee__c CurrentContact:TriggerNew) {
            if(MapOfMeetingInvToCont.containsKey(CurrentContact.Invitation__c)) {
                for(Customer_Attendee__c PresentRec:MapOfMeetingInvToCont.get(CurrentContact.Invitation__c)){    
                   
                        if(CurrentContact.RecordTypeId==PresentRec.RecordTypeId) {
                           
                            if(CurrentContact.RecordTypeId==MapOfRTIDToRTName.get('Contact_Related')) {
                                if(CurrentContact.Contact__c==null) {
                                    CurrentContact.addError(System.Label.Customer_Attendee_No_Contact_Selected);
                                }
                                if(CurrentContact.Contact__c==PresentRec.Contact__c&&isInsert) {
                                    CurrentContact.addError(System.Label.Customer_Attendee_Contact_Present_In_the_Meeting);
                                }
                                
                                                                }
                            else if(CurrentContact.RecordTypeId==MapOfRTIDToRTName.get('Lead_Related')) {
                                if(CurrentContact.Lead__c==PresentRec.Lead__c&&isInsert) {
                                    CurrentContact.addError(System.Label.Customer_Attendee_Lead_Already_Present_in_the_Meeting);
                                }
                                if(CurrentContact.Lead__c==null) {
                                    CurrentContact.addError(System.Label.Customer_Attendee_No_Lead_Selected_in_Standard_Page);
                                }
                            }
                        }
                    
                }
            }
        }
       
        for(Customer_Attendee__c CurrentContact:TriggerNew) {
            if(MapOfMeetingToRecordType.containsKey(CurrentContact.Invitation__c)) {
               
                if(MapOfMeetingToRecordType.get(CurrentContact.Invitation__c)!=CurrentContact.RecordTypeId)
                    if(CurrentContact.RecordTypeId==MapOfRTIDToRTName.get('Lead_Related'))
                        CurrentContact.addError(System.Label.Customer_Attendee_Only_Contacts_Can_Be_Added);
                    else if(CurrentContact.RecordTypeId==MapOfRTIDToRTName.get('Contact_Related'))
                        CurrentContact.addError(System.Label.Customer_Attendee_Only_Leads_Can_Be_Added);
                else                
                    continue;
            }
            else
                continue;
        }
    }
    
    public void updateRelationDetails(List<Customer_Attendee__c> TriggerNew){
        set<Id> setOfLeadIds = new set<Id>();
        set<Id> setOfContactIds = new set<Id>();
        set<Id> setOfInvitationIds = new set<Id>();
        Map<Id,Lead> mapOfIdToLead;
        Map<Id,Contact> mapOfIdToContact;
        String attendeeEmail = '';
        if(isError) {
            Integer i=1/0;
        }
        for(Customer_Attendee__c iterInv : TriggerNew){
        system.debug('iterInvvvvv '+iterInv );
            if(iterInv.Type__c == null ){
                if(iterInv.Lead__c != null && iterInv.contact__c == null){
                    setOfLeadIds.add(iterInv.Lead__c);
                }
                if(iterInv.contact__c!= null && iterInv.Lead__c == null){
                    setOfContactIds.add(iterInv.contact__c);
                }
            }
            setOfInvitationIds.add(iterInv.Invitation__c);
        }
        
        system.debug('CONTACT IDS--'+setOfContactIds);
        system.debug('LEAD IDS--'+setOfLeadIds);
        if(setOfLeadIds != null && setOfLeadIds.size()>0){
            mapOfIdToLead = new Map<Id,Lead>([select firstName, lastname, email, phone from Lead where Id in: setOfLeadIds ]);
        }        
        
        if(setOfContactIds!= null && setOfContactIds.size()>0){
            mapOfIdToContact = new Map<Id,Contact>([select firstName, lastname, email, phone from Contact where Id in: setOfContactIds]);
        }     

        system.debug('mapOfIdToContactttt '+mapOfIdToContact );
        for(Customer_Attendee__c iterInv : TriggerNew){
            if(iterInv.Lead__c != null && iterInv.contact__c == null && mapOfIdToLead!= null && mapOfIdToLead.containsKey(iterInv.Lead__c)){
                iterInv.Attendee_First_Name__c = mapOfIdToLead.get(iterInv.Lead__c).firstName;
                iterInv.Attendee_Last_Name__c = mapOfIdToLead.get(iterInv.Lead__c).LastName;
                iterInv.Attendee_Phone__c = mapOfIdToLead.get(iterInv.Lead__c).Phone;
                iterInv.Attendee_Email__c = mapOfIdToLead.get(iterInv.Lead__c).Email;
                if(attendeeEmail == '')
                    attendeeEmail = mapOfIdToLead.get(iterInv.Lead__c).Email;
                iterInv.Type__c = 'Lead';
                iterInv.Who_ID__c = iterInv.Lead__c;
                iterInv.Primary__c = true;
            }
            if(iterInv.contact__c!= null && iterInv.Lead__c == null && mapOfIdToContact!= null && mapOfIdToContact.containsKey(iterInv.Contact__c)){
                iterInv.Attendee_First_Name__c = mapOfIdToContact.get(iterInv.contact__c).firstName;
                iterInv.Attendee_Last_Name__c = mapOfIdToContact.get(iterInv.contact__c).LastName;
                iterInv.Attendee_Phone__c = mapOfIdToContact.get(iterInv.contact__c).Phone;
                iterInv.Attendee_Email__c = mapOfIdToContact.get(iterInv.contact__c).Email;
                if(attendeeEmail == '')
                    attendeeEmail = mapOfIdToContact.get(iterInv.contact__c).Email;
                iterInv.Type__c = 'Contact';
                iterInv.Who_ID__c = iterInv.contact__c;
                iterInv.Primary__c = true;
            }
        }

        
    }

    public void updateInvitationDetails(List<Customer_Attendee__c> TriggerNew){
        set<Id> setOfInvitationIds = new set<Id>();
        
        for(Customer_Attendee__c iterInv : TriggerNew){
            setOfInvitationIds.add(iterInv.Invitation__c);
        }
        
        Invitation__c inviteToUpdate = [select Id,Attendee_Email__c,Attendee_Schedule_URL__c from Invitation__c where Id in: setOfInvitationIds LIMIT 1];
        if(String.isBlank(inviteToUpdate.Attendee_Email__c) || String.isBlank(inviteToUpdate.Attendee_Schedule_URL__c)){
            inviteToUpdate.Attendee_Email__c = TriggerNew[0].Attendee_Email__c;
            system.debug('Urlllll '+TriggerNew[0].Schedule_URL__c);
            inviteToUpdate.Attendee_Schedule_URL__c = TriggerNew[0].Schedule_URL__c.replace('&','%26');
        }
        update inviteToUpdate;
    }
   
}