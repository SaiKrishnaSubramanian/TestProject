public class WebExHelper {
    
    @future (callout=true)
    public static void createWebex(ID evtID, String MeetingName, String MeetingPassword, String UserName, String UserPassword, datetime meetingStart, integer meetingDuration, string timezone)
    {
        String meetingNumber = '';
        String joinURL = '';
        String webExError = '';      
        if (String.isBlank(MeetingPassword))
        {
            MeetingPassword = generateRandomString(6);
        }
        Event ev = new Event();
        ev = [select Id,TimeTrade_Debug_Log__c from Event where Id =: evtID];
        try {
            
            
            HttpRequest setMeetingReq = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            TTLinkalatorSettings__c ttCathedralSettings = TTLinkalatorSettings__c.getOrgDefaults();
            
            setMeetingReq.setEndpoint('https://' + ttCathedralSettings.WebEx_Site_Name__c + '.webex.com/WBXService/XMLService');
            setMeetingReq.setMethod('POST');
            setMeetingReq.setBody('<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service"><header><securityContext><siteName>' + 
                                  ttCathedralSettings.WebEx_Site_Name__c + '</siteName><webExID>' + 
                                  UserName + '</webExID><password>' + 
                                  UserPassword + '</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.meeting.CreateMeeting"><accessControl><meetingPassword>' + 
                                  EncodingUtil.urlEncode(MeetingPassword, 'UTF-8') + '</meetingPassword></accessControl><metaData><confName>' + 
                                  EncodingUtil.urlEncode(MeetingName, 'UTF-8').replace('+',' ') + '</confName></metaData><schedule><startDate>' + 
                                  meetingStart.format('MM/dd/yyyy HH:mm:ss', timezone) + '</startDate><joinTeleconfBeforeHost>true</joinTeleconfBeforeHost><duration>' + 
                                  string.valueOf(meetingDuration) + '</duration></schedule><enableOptions><attendeeList>true</attendeeList></enableOptions><telephony><telephonySupport>CALLIN</telephonySupport></telephony></bodyContent></body></serv:message>');
            
            if (!Test.isRunningTest()) res = http.send(setMeetingReq);
            
            //system.debug(res.getBody());
            
            
            if (res.getStatusCode() == 200 || Test.isRunningTest())
            {
                String bodyText = !Test.isRunningTest() ? res.getBody() : '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:com="http://www.webex.com/schemas/2002/06/common" xmlns:meet="http://www.webex.com/schemas/2002/06/service/meeting" xmlns:att="http://www.webex.com/schemas/2002/06/service/attendee"> <serv:header> <serv:response> <serv:result>SUCCESS</serv:result> <serv:gsbStatus>PRIMARY</serv:gsbStatus> </serv:response> </serv:header> <serv:body> <serv:bodyContent xsi:type="meet:createMeetingResponse" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <meet:meetingkey>622157058</meet:meetingkey> <meet:iCalendarURL> <serv:host>https://timetrade.webex.com/timetrade/j.php?MTID=m3523138af57321183b5f001aa34056b0</serv:host> <serv:attendee>https://timetrade.webex.com/timetrade/j.php?MTID=m90f46254be73bb285a1c7773624117a5</serv:attendee> </meet:iCalendarURL> <meet:guestToken>73d4bfb33925c2fe02cfb44a75e180e0</meet:guestToken> </serv:bodyContent> </serv:body></serv:message>';
                XmlStreamReader reader = new XmlStreamReader(bodyText);
                boolean isSafeToGetNextXmlElement = true;
                boolean getWebExURL = false;
                while(isSafeToGetNextXmlElement) 
                {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) 
                    {

                        if ('result' == reader.getLocalName())
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'SUCCESS') {
                                    getWebExURL = true;
                                }
                                else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'FAILURE') {
                                    getWebExURL = false;
                                    break;
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        if ('reason' == reader.getLocalName() && !getWebExURL)
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS){
                                    webExError = reader.getText();
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        if ('meetingkey' == reader.getLocalName())
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                                    meetingNumber = reader.getText();
                                    break;
                                }
                                if (reader.hasNext())reader.next();
                                else {innerSafe = false; break;}
                            }
                        }
                    }
                    // Always use hasNext() before calling next() to confirm
                    // that we have not reached the end of the stream
                    if (reader.hasNext()) {
                        reader.next();
                    } else {
                        isSafeToGetNextXmlElement = false;
                        break;
                    }
                }
            }
            
            system.debug('added the webex. Now getting the link...');
            //Get meeting URL (ie. https://timetrade.webex.com/timetrade/j.php?MTID=me26993723002de12aeca93f16715a18c)
            setMeetingReq.setBody('<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><header><securityContext><siteName>' + 
                                  ttCathedralSettings.WebEx_Site_Name__c + '</siteName><webExID>' + 
                                  UserName + '</webExID><password>' + 
                                  UserPassword + '</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.meeting.GetjoinurlMeeting"><sessionKey>' + 
                                  meetingNumber + '</sessionKey></bodyContent></body></serv:message>');
            
            if (!Test.isRunningTest()) res = http.send(setMeetingReq);
            if (res.getStatusCode() == 200 && webExError != null)
            {
                String bodyText = !Test.isRunningTest() ? res.getBody() : '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:com="http://www.webex.com/schemas/2002/06/common" xmlns:meet="http://www.webex.com/schemas/2002/06/service/meeting" xmlns:att="http://www.webex.com/schemas/2002/06/service/attendee"> <serv:header> <serv:response> <serv:result>SUCCESS</serv:result> <serv:gsbStatus>PRIMARY</serv:gsbStatus> </serv:response> </serv:header> <serv:body> <serv:bodyContent xsi:type="meet:getjoinurlMeetingResponse" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <meet:joinMeetingURL>https://timetrade.webex.com/timetrade/e.php?AT=SI&amp;MK=623765431</meet:joinMeetingURL> <meet:inviteMeetingURL>https://timetrade.webex.com/timetrade/j.php?MTID=mb6085002f7512659e4a032fdbc870529</meet:inviteMeetingURL> </serv:bodyContent> </serv:body></serv:message>';
                XmlStreamReader reader = new XmlStreamReader(bodyText);
                boolean isSafeToGetNextXmlElement = true;
                boolean getWebExURL = false;
                while(isSafeToGetNextXmlElement) 
                {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) 
                    {
                        if ('result' == reader.getLocalName())
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'SUCCESS') {
                                    getWebExURL = true;
                                }
                                else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'FAILURE') {
                                    getWebExURL = false;
                                    break;
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        if ('reason' == reader.getLocalName() && !getWebExURL)
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS){
                                    webExError = reader.getText();
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        if ('inviteMeetingURL' == reader.getLocalName())
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                                    joinURL = reader.getText();
                                }
                                if (reader.hasNext())reader.next();
                                else {innerSafe = false; break;}
                            }
                        }
                    }
                    // Always use hasNext() before calling next() to confirm
                    // that we have not reached the end of the stream
                    if (reader.hasNext()) {
                        reader.next();
                    } else {
                        isSafeToGetNextXmlElement = false;
                        break;
                    }
                }
            }
            
            
            system.debug('eventttt '+ev);
            if (String.isNotBlank(joinURL) && String.isNotBlank(meetingNumber)) 
            {
                EmailTemplateMergeUtil.eventWebConferenceDetails(evtID,meetingNumber, joinURL,  MeetingPassword,ttCathedralSettings.WebEx_DialIn_Number__c,ttCathedralSettings.WebEx_Additional_Numbers_URL__c );
                
            }

            if(webExError!= null && webExError!= ''){
                //Insert Debug Log object whenever there is an error
               /* Debug_Log__c Log=new Debug_Log__c();
                Log.Record_Detail__c=evtID;
                //Log.Error_Description__c=;
                Log.Exception_Type__c='WebEx Callout Error';
                Log.Error_Message__c=webExError;
                insert Log;*/
                
                ev.TimeTrade_Debug_Log__c  =ExceptionHandler.InsertDebugLog(null,evtID,'',webExError,'WebEx Callout Error');
                update ev;
            }
        } 
        catch(System.CalloutException ex) {
            //Insert Debug Log object whenever there is an error
          /*  Debug_Log__c Log=new Debug_Log__c();
            Log.Line_Number__c=ex.getLineNumber();
            Log.Record_Detail__c=evtID;
            Log.Error_Description__c=ex.getStackTraceString();
            Log.Exception_Type__c=ex.getTypeName();
            Log.Error_Message__c=ex.getMessage();
            insert Log;*/
            system.debug('eventttt '+ev);
            ev.TimeTrade_Debug_Log__c  =  ExceptionHandler.InsertDebugLog(ex.getLineNumber(),evtID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            update ev;
           // exceptionHandler(ex,evtID);
            return;
        }
        
        
    }
    
   /* public static void exceptionHandler(System.CalloutException ex, Id evtID){
        Debug_Log__c Log=new Debug_Log__c();
        Log.Line_Number__c=ex.getLineNumber();
        Log.Record_Detail__c=evtID;
        Log.Error_Description__c=ex.getStackTraceString();
        Log.Exception_Type__c=ex.getTypeName();
        Log.Error_Message__c=ex.getMessage();
        insert Log;
    }*/

    @future (callout=true)
    public static void updateWebex(Id evtID,String UserName, String UserPassword, dateTime meetingStart, string meetingKey, integer meetingDuration, string timezone)
    {
        String webExError = '';
        HttpRequest setMeetingReq = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        TTLinkalatorSettings__c ttCathedralSettings = TTLinkalatorSettings__c.getOrgDefaults();
        Event ev = new Event();
        ev = [select Id,TimeTrade_Debug_Log__c from Event where Id =: evtID];
        try {
            
            setMeetingReq.setEndpoint('https://' + ttCathedralSettings.WebEx_Site_Name__c + '.webex.com/WBXService/XMLService');
            setMeetingReq.setMethod('POST');
            setMeetingReq.setBody('<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service"><header><securityContext><siteName>' + 
                                  ttCathedralSettings.WebEx_Site_Name__c + '</siteName><webExID>' + 
                                  UserName + '</webExID><password>' + 
                                  UserPassword + '</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.meeting.SetMeeting"><schedule><startDate>' + 
                                  meetingStart.format('MM/dd/yyyy HH:mm:ss', timezone) + '</startDate><joinTeleconfBeforeHost>true</joinTeleconfBeforeHost><duration>' + 
                                  string.valueOf(meetingDuration) + '</duration></schedule><meetingkey>' +
                                  meetingKey + '</meetingkey></bodyContent></body></serv:message>');
            
            if (!Test.isRunningTest())res = http.send(setMeetingReq);
            if (res.getStatusCode() == 200 )
            {
                ///String bodyText = !Test.isRunningTest() ? res.getBody() : '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:com="http://www.webex.com/schemas/2002/06/common" xmlns:meet="http://www.webex.com/schemas/2002/06/service/meeting" xmlns:att="http://www.webex.com/schemas/2002/06/service/attendee"> <serv:header> <serv:response> <serv:result>SUCCESS</serv:result> <serv:gsbStatus>PRIMARY</serv:gsbStatus> </serv:response> </serv:header> <serv:body> <serv:bodyContent xsi:type="meet:getjoinurlMeetingResponse" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <meet:joinMeetingURL>https://timetrade.webex.com/timetrade/e.php?AT=SI&amp;MK=623765431</meet:joinMeetingURL> <meet:inviteMeetingURL>https://timetrade.webex.com/timetrade/j.php?MTID=mb6085002f7512659e4a032fdbc870529</meet:inviteMeetingURL> </serv:bodyContent> </serv:body></serv:message>';
                XmlStreamReader reader = new XmlStreamReader(res.getBody());
                boolean isSafeToGetNextXmlElement = true;
                boolean getWebExURL = false;
                while(isSafeToGetNextXmlElement) 
                {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) 
                    {
                        if ('result' == reader.getLocalName())
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'SUCCESS') {
                                    getWebExURL = true;
                                }
                                else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'FAILURE') {
                                    getWebExURL = false;
                                    break;
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        if ('reason' == reader.getLocalName() && !getWebExURL)
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS){
                                    webExError = reader.getText();
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        
                    }
                    // Always use hasNext() before calling next() to confirm
                    // that we have not reached the end of the stream
                    if (reader.hasNext()) {
                        reader.next();
                    } else {
                        isSafeToGetNextXmlElement = false;
                        break;
                    }
                }
            }
            
            if(webExError!= null && webExError!= '' ){
            /*    Debug_Log__c Log=new Debug_Log__c();
                Log.Record_Detail__c=evtID;
                //Log.Error_Description__c=;
                Log.Exception_Type__c='WebEx Callout Error';
                Log.Error_Message__c=webExError;
                insert Log;*/
                
                ev.TimeTrade_Debug_Log__c  = ExceptionHandler.InsertDebugLog(null,evtID,'',webExError,'WebEx Callout Error');
                update ev;
            }
        } 
        catch(System.CalloutException ex) {
            //Insert Debug Log object whenever there is an error//Insert Debug Log object whenever there is an error
          /*  Debug_Log__c Log=new Debug_Log__c();
            Log.Line_Number__c=ex.getLineNumber();
            Log.Record_Detail__c=evtID;
            Log.Error_Description__c=ex.getStackTraceString();
            Log.Exception_Type__c=ex.getTypeName();
            Log.Error_Message__c=ex.getMessage();
            insert Log;*/
            
            ev.TimeTrade_Debug_Log__c  = ExceptionHandler.InsertDebugLog(ex.getLineNumber(),evtID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());
            update ev;
         //   exceptionHandler(ex,evtID);
            return;
        }
        
        return;
    }
    
    @future (callout=true)
    public static void CancelWebex(ID evtID,String meetingNumber, string userName, string password) {
        string webExError = '';
        Event ev = new Event();
        ev = [select Id,TimeTrade_Debug_Log__c from Event where Id =: evtID];
        try
        {
            TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
            HttpRequest setMeetingReq = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            //Cancel the webEx
            setMeetingReq.setEndpoint('https://' + TTLinkalatorSettings.WebEx_Site_Name__c + '.webex.com/WBXService/XMLService');
            setMeetingReq.setMethod('POST');
            setMeetingReq.setBody('<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:serv="http://www.webex.com/schemas/2002/06/service"><header><securityContext><siteName>' + 
                                  TTLinkalatorSettings.WebEx_Site_Name__c + '</siteName><webExID>' + 
                                  userName + '</webExID><password>' + 
                                  password + '</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.meeting.DelMeeting"><meetingKey>' + 
                                  EncodingUtil.urlEncode(meetingNumber, 'UTF-8') + '</meetingKey></bodyContent></body></serv:message>');
            
            if (!Test.isRunningTest()) res = http.send(setMeetingReq);
            if (res.getStatusCode() == 200 )
            {
                ///String bodyText = !Test.isRunningTest() ? res.getBody() : '<?xml version="1.0" encoding="UTF-8"?><serv:message xmlns:serv="http://www.webex.com/schemas/2002/06/service" xmlns:com="http://www.webex.com/schemas/2002/06/common" xmlns:meet="http://www.webex.com/schemas/2002/06/service/meeting" xmlns:att="http://www.webex.com/schemas/2002/06/service/attendee"> <serv:header> <serv:response> <serv:result>SUCCESS</serv:result> <serv:gsbStatus>PRIMARY</serv:gsbStatus> </serv:response> </serv:header> <serv:body> <serv:bodyContent xsi:type="meet:getjoinurlMeetingResponse" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <meet:joinMeetingURL>https://timetrade.webex.com/timetrade/e.php?AT=SI&amp;MK=623765431</meet:joinMeetingURL> <meet:inviteMeetingURL>https://timetrade.webex.com/timetrade/j.php?MTID=mb6085002f7512659e4a032fdbc870529</meet:inviteMeetingURL> </serv:bodyContent> </serv:body></serv:message>';
                XmlStreamReader reader = new XmlStreamReader(res.getBody());
                boolean isSafeToGetNextXmlElement = true;
                boolean getWebExURL = false;
                while(isSafeToGetNextXmlElement) 
                {
                    if (reader.getEventType() == XmlTag.START_ELEMENT) 
                    {
                        if ('result' == reader.getLocalName())
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'SUCCESS') {
                                    getWebExURL = true;
                                }
                                else if (reader.getEventType() == XmlTag.CHARACTERS && reader.getText() == 'FAILURE') {
                                    getWebExURL = false;
                                    break;
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        if ('reason' == reader.getLocalName() && !getWebExURL)
                        {
                            boolean innerSafe = true;
                            while(innerSafe)
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT) {
                                    break;
                                } else if (reader.getEventType() == XmlTag.CHARACTERS){
                                    webExError = reader.getText();
                                }
                                if (reader.hasNext() && !getWebExURL){
                                    reader.next();
                                }    
                                else {
                                    innerSafe = false; 
                                    break;
                                }
                            }
                        }

                        
                    }
                    // Always use hasNext() before calling next() to confirm
                    // that we have not reached the end of the stream
                    if (reader.hasNext()) {
                        reader.next();
                    } else {
                        isSafeToGetNextXmlElement = false;
                        break;
                    }
                }
            }
            
            if(webExError!= null && webExError!= '' ){
              /*  Debug_Log__c Log=new Debug_Log__c();
                Log.Record_Detail__c=evtID;
                //Log.Error_Description__c=;
                Log.Exception_Type__c='WebEx Callout Error';
                Log.Error_Message__c=webExError;
                insert Log;*/
                
                ev.TimeTrade_Debug_Log__c  = ExceptionHandler.InsertDebugLog(null,evtID,'',webExError,'WebEx Callout Error');
                update ev;
            }
        }
        catch(System.CalloutException ex) {
            //Insert Debug Log object whenever there is an error
           // exceptionHandler(ex,evtID);//Insert Debug Log object whenever there is an error
          
          /*  Debug_Log__c Log=new Debug_Log__c();
            Log.Line_Number__c=ex.getLineNumber();
            Log.Record_Detail__c=evtID;
            Log.Error_Description__c=ex.getStackTraceString();
            Log.Exception_Type__c=ex.getTypeName();
            Log.Error_Message__c=ex.getMessage();
            insert Log;*/
            
            ev.TimeTrade_Debug_Log__c  =  ExceptionHandler.InsertDebugLog(ex.getLineNumber(),evtID,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName()) ;
            update ev;
            return;
        }
        
    }
    
    public static String generateRandomString(Integer len) {
    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    String randStr = '';
    while (randStr.length() < len) {
       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
       randStr += chars.substring(idx, idx+1);
    }
    return randStr; 
}
}