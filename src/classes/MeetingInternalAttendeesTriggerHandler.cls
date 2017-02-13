public class MeetingInternalAttendeesTriggerHandler {
    public void updateUniqueness(List<Internal_Attendee__c> TriggerNew,Map<ID,Internal_Attendee__c> NewMap,Map<ID,Internal_Attendee__c> OldMap,Boolean Isupdate) {
        set<ID> MeetingInvIDs=new set<ID>();
        Map<ID,List<Internal_Attendee__c>> MapOfMeetingInvToInternalAttend=new Map<ID,List<Internal_Attendee__c>>();
        
        for(Internal_Attendee__c temp:TriggerNew) {
            MeetingInvIDs.add(temp.Invitation__c);
                temp.Uniqueness__c=temp.Invitation__c+'-'+temp.Name__c;
        }
        
        for(Internal_Attendee__c temp:[SELECT ID,Organizer__c,Invitation__c FROM Internal_Attendee__c WHERE Invitation__c IN:MeetingInvIDs]) {
            if(MapOfMeetingInvToInternalAttend.containsKey(temp.Invitation__c)) {
                MapOfMeetingInvToInternalAttend.get(temp.Invitation__c).add(temp);
            }
            else
            {
                MapOfMeetingInvToInternalAttend.put(temp.Invitation__c,new List<Internal_Attendee__c>{temp});
            }
        }
        if(!Isupdate) {
            
        
        for(Internal_Attendee__c temp:TriggerNew) {
            if(MapOfMeetingInvToInternalAttend.containsKey(temp.Invitation__c)) {
                for(Internal_Attendee__c tempInv:MapOfMeetingInvToInternalAttend.get(temp.Invitation__c))
                {
                    if(temp.Organizer__c==true&&tempInv.Organizer__c==true) 
                   {
                        temp.addError(System.Label.Internal_Attendee_Organizer_Already_Present);
                    }
                    else
                        continue;
                                    }
                
            }
            else
                continue;
            
        }
            }
        for(Internal_Attendee__c temp:TriggerNew) {
            if(MapOfMeetingInvToInternalAttend.containsKey(temp.Invitation__c)) {
                for(Internal_Attendee__c tempInv:MapOfMeetingInvToInternalAttend.get(temp.Invitation__c)) {
                    if(Isupdate) {
                        if(OldMap.get(temp.ID).Organizer__c==true&&NewMap.get(temp.ID).Organizer__c==false) {
                            temp.addError(System.Label.Internal_Attendee_Cannot_Uncheck_Organizer);
                        }
                    }
                }
            } 
        }
    }   
    
    public void PreventDelete(List<Internal_Attendee__c> TriggerOld) {
        for(Internal_Attendee__c temp:TriggerOld) {
            if(temp.Organizer__c==true)
                    temp.addError(System.Label.Internal_Attendee_Deleting_Meeting_Organizer);
        }
    }
}