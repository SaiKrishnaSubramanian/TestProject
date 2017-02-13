public class testDataDump{

    public static Meeting__c createMeeting(Id InvitationId){
        Meeting__c meeting = new Meeting__c();
        meeting.Invitation__c = InvitationId;
        insert meeting;
        return meeting;
    }
}