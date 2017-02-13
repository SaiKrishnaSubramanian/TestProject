public class ZoomHelper {
    
    @future (callout=true)
    public static void CreateMeeting(ID evtID, String MeetingName, String MeetingPassword, String UserName, String TimeZone, datetime meetingStart, integer meetingDuration)
    {
        try {
            TTLinkalatorSettings__c ttCathedralSettings = TTLinkalatorSettings__c.getOrgDefaults();
            HttpRequest req = new HttpRequest();
            req.SetEndpoint('callout:ZoomAPI' + '/meeting/create');
            req.setBody('api_key={!$Credential.UserName}&api_secret={!$Credential.Password}' +
                        '&host_id=' + UserName +
                        '&topic=' + MeetingName +
                        '&type=2' +
                        '&start_time=' + meetingStart.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z' +
                        '&duration=' + meetingDuration +
                        '&timezone=' + TimeZone +
                        '&password=' + MeetingPassword);
            
            req.setMethod('GET');
            Http http = new Http();
            HttpResponse res = new HttpResponse();
            
            if (!Test.isRunningTest()) res = http.send(req);
            system.debug('ressss '+res.getbody());
            string meetingID = '';
            string joinURL = '';
            string resBody = !Test.isRunningTest() ? res.getBody() : '{"id": 123456789,"join_url": "https://zoom.us/j/123456789"}';
            JSONParser parser = JSON.createParser(resBody);
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'id')) {
                        // Get the value.
                        parser.nextToken();
                        // Compute the grand total price for all invoices.
                        meetingID = parser.getText();
                    }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'join_url')) {
                        // Get the value.
                        parser.nextToken();
                        // Compute the grand total price for all invoices.
                        joinURL = parser.getText();
                    }
            }
            
            if (String.isNotBlank(meetingID) && String.isNotBlank(joinURL))
            {
                EmailTemplateMergeUtil.eventWebConferenceDetails(evtID,meetingID, joinURL,  MeetingPassword,ttCathedralSettings.Zoom_DialIn_Number__c, ttCathedralSettings.Zoom_Additional_Numbers_URL__c);
            }
        }
        catch(System.CalloutException ex) {
            System.debug('Callout error on line ' + ex.getLineNumber() + ': ' + ex.getMessage());
            exceptionHandler(ex, evtID);
       //    ExceptionHandler.InsertDebugLog(ex.getLineNumber(),(ID)evtID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

        }

    }
    
    @future (callout=true)
    public static void UpdateMeeting(Id evtId,String UserName, dateTime meetingStart, string meetingId, integer meetingDuration)
    {
        try {
            
            HttpRequest req = new HttpRequest();
            req.SetEndpoint('callout:ZoomAPI' + '/meeting/update');
            req.setBody('api_key={!$Credential.UserName}&api_secret={!$Credential.Password}' +
                        '&id=' + meetingId +
                        '&host_id=' + UserName +
                        '&start_time=' + meetingStart.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z' +
                        '&duration=' + meetingDuration);
            
            req.setMethod('GET');
            Http http = new Http();
            HttpResponse res = new HttpResponse();
            if (!Test.isRunningTest()) res = http.send(req);
            
        }
        catch(System.CalloutException ex) {
            
            System.debug('Callout error on line ' + ex.getLineNumber() + ': ' + ex.getMessage());
            exceptionHandler(ex, evtId);
           // ExceptionHandler.InsertDebugLog(ex.getLineNumber(),(ID)evtID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

        }
    }
    
    @future (callout=true)
    public static void CancelMeeting(Id evtId, String hostID, String meetingId)
    {
        try {
            
            HttpRequest req = new HttpRequest();
            req.SetEndpoint('callout:ZoomAPI' + '/meeting/delete');
            req.setBody('api_key={!$Credential.UserName}&api_secret={!$Credential.Password}' +
                        '&id=' + meetingId +
                        '&host_id=' + hostID);
            
            req.setMethod('GET');
            Http http = new Http();
            HttpResponse res = new HttpResponse();
            if (!Test.isRunningTest()) res = http.send(req);
            
        }
        catch(System.CalloutException ex) {
            System.debug('Callout error on line ' + ex.getLineNumber() + ': ' + ex.getMessage());
            exceptionHandler(ex, evtId);
           //ExceptionHandler.InsertDebugLog(ex.getLineNumber(),(ID)evtID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

        }
        return;
    }
    
     public static void exceptionHandler(System.CalloutException ex, Id evtID){
        Debug_Log__c Log=new Debug_Log__c();
        Log.Line_Number__c=ex.getLineNumber();
        Log.Record_Detail__c=evtID;
        Log.Error_Description__c=ex.getStackTraceString();
        Log.Exception_Type__c=ex.getTypeName();
        Log.Error_Message__c=ex.getMessage();
        insert Log;
        
        Event ev = new Event();
        ev = [select TimeTrade_Debug_Log__c from Event where Id =: evtID];
        ev.TimeTrade_Debug_Log__c =Log.Id;
        update ev;
            
        
    }
}