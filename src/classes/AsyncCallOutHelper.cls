public class AsyncCallOutHelper {

    @future (callout=true)
    public static void copyCheckResource(string userExternalID, string userName, string timeZoneName)
    {
        try
        {
            //first see if the resource is there
            TTConfigurationWS.ConfigurationWS myTTCS = new TTConfigurationWS.ConfigurationWS();
            TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
            myTTCS.SetEndpoint('callout:TimeTradeAPI' + '/ConfigurationServices');
            myTTCS.SetSecurity('{!$Credential.UserName}', '{!$Credential.Password}');
            
            TTConfigurationServices.resource myResource = new TTConfigurationServices.resource();
            if(!Test.isRunningTest()) myResource = myTTCS.getResourceByExternalId(TTLinkalatorSettings.Location_External_ID__c, userExternalID);
            
            if (myResource == null || String.IsBlank(myResource.resourceExternalId))
            {
                //We need to create the resource
                TTConfigurationWS.TTStatus copyStatus;
                if(!Test.isRunningTest()) copyStatus = myTTCS.copyResourceDeep(TTLinkalatorSettings.Location_External_ID__c,TTLinkalatorSettings.Template_Resource_ExternalID__c,TTLinkalatorSettings.Location_External_ID__c,userExternalID);
                
                //get resource again
                if(!Test.isRunningTest()) myResource = myTTCS.getResourceByExternalId(TTLinkalatorSettings.Location_External_ID__c, userExternalID);
                
                //Update name and timeZone
                myResource.resourceName = userName;
                myResource.timezone = timeZoneName;
                TTConfigurationWS.resourceRules newRules = new TTConfigurationWS.resourceRules();
                newRules.applyTimezone = true;
                myResource.resourceRules = newRules;
                
                TTConfigurationWS.TTStatus updateStatus;
                if(!Test.isRunningTest()) updateStatus = myTTCS.updateInsertResource(myResource);
                
            }
        }
        catch(Exception ex)
        {
             ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

            system.debug('Exception on line ' + ex.getLineNumber() + ' : ' + ex.getMessage());
        }
        
    }
    
    @future (callout=true)
    public static void futureSetStatusLifecycle(string confirmation, string status) {
         try
         {
        	//Field was changed, lets update
            TTAppointmentWS.AppointmentWS myTTAS = new TTAppointmentWS.AppointmentWS();
            TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
            myTTAS.SetEndpoint('callout:TimeTradeAPI' + '/AppointmentServices');
        	myTTAS.SetSecurity('{!$Credential.UserName}', '{!$Credential.Password}');
            
            TTAppointmentWS.appointmentLifeCycleStateChange lfState = new TTAppointmentWS.appointmentLifeCycleStateChange();
            lfState.appointmentState = status;
            if (!Test.isRunningTest()) TTAppointmentWS.TTStatus lifecyclestatus = myTTAS.setAppointmentLifeCycleState(lfState, confirmation);
         }
        catch(Exception ex)
        {
            system.debug('Exception: ' + ex.getMessage());
             ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

             //Insert Debug Log object whenever there is an error
            /*	Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();               	
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Exception_Type__c=ex.getTypeName();
            	Log.Error_Message__c=ex.getMessage();
                insert Log;*/
        }
    }
    
    @future (callout=true)
    public static void futureCancelMeeting(string apptConfirmation) {
        
        try
        {
            //Field was changed, lets update
            TTAppointmentWS.AppointmentWS myTTAS = new TTAppointmentWS.AppointmentWS();
            TTLinkalatorSettings__c TTLinkalatorSettings = TTLinkalatorSettings__c.getOrgDefaults();
            myTTAS.SetEndpoint('callout:TimeTradeAPI' + '/AppointmentServices');
        	myTTAS.SetSecurity('{!$Credential.UserName}', '{!$Credential.Password}');
            
            if (!Test.isRunningTest()) TTAppointmentWS.TTStatus cancelstatus = myTTAS.cancelAppointment(apptConfirmation);
        }
        catch(Exception ex)
        {
            system.debug('Exception: ' + ex.getMessage());
             ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

              //Insert Debug Log object whenever there is an error
            /*	Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();               	
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Exception_Type__c=ex.getTypeName();
            	Log.Error_Message__c=ex.getMessage();
                insert Log;*/
        }
        
    }
    
   /* @future (callout=true)
    public static void CancelWebex(String meetingNumber, string userName, string password) {
        
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
                                  TTLinkalatorSettings.WebEx_Site_Name__c + '</siteName><siteID>' + 
                                  TTLinkalatorSettings.Webex_SiteID__c + '</siteID><webExID>' + 
                                  userName + '</webExID><password>' + 
                                  password + '</password></securityContext></header><body><bodyContent xsi:type="java:com.webex.service.binding.meeting.DelMeeting"><meetingKey>' + 
                                  EncodingUtil.urlEncode(meetingNumber, 'UTF-8') + '</meetingKey></bodyContent></body></serv:message>');
            
            if (!Test.isRunningTest()) res = http.send(setMeetingReq);
        }
        catch(Exception ex)
        {
            system.debug('Exception: ' + ex.getMessage());
             ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

             //Insert Debug Log object whenever there is an error
            	Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();               	
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Exception_Type__c=ex.getTypeName();
            	Log.Error_Message__c=ex.getMessage();
                insert Log;
        }
        
    }*/
}