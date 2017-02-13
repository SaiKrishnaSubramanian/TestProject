public class ExceptionHandler {
    public static ID InsertDebugLog(Integer LineNo,ID RecordId,String stacktrace,String message,String ExType) {
                Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=LineNo;
                if(RecordId!=null)
            Log.Record_Detail__c=RecordId;
                Log.Error_Description__c=stacktrace;
                Log.Error_Message__c=message;
                Log.Exception_Type__c=ExType;
                insert Log;
                return Log.Id;
       
    }
}