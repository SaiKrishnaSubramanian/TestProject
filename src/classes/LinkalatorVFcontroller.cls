public class LinkalatorVFcontroller {

    public Invitation__c  myLinkalator;
    public boolean sendMail{get;set;}
    
    public LinkalatorVFcontroller()
    {
        //For testing passing nothing
        List<string> props = new List<string>();
        props.add('Name');
        props.add('Send_Email__c');
        sendMail= false;
        myLinkalator = new Invitation__c();
    }
    public LinkalatorVFcontroller(ApexPages.standardController std) {
        if(!String.isEmpty(std.getID())){
            List<Invitation__c> listOfInvitations = new List<Invitation__c>([select Id, Name, Send_Email__c from Invitation__c where Id=:std.getID() ]);
            myLinkalator = listOfInvitations[0];
        }
        
        
    }

    public PageReference CheckInternalAttendee(){
        Integer countOfCustomers = [select count() from Customer_Attendee__c where Invitation__c =: myLinkalator.Id]; 
        if(countOfCustomers > 0)
            sendMail = true;
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add at least one invitee to send the TimeTrade Invitation.'));
               
        }    
        return null; 
    }

    public PageReference save() {
        try{
                sendMail = true;
                if (myLinkalator.Send_Email__c){
                    myLinkalator.Send_Email__c = false;
                    update myLinkalator;
                }
        
                myLinkalator.Send_Email__c = true;
                update myLinkalator;
            
            
            
        }
       catch (Exception ex) 
            {              
                //Insert Debug Log object whenever there is an error
                ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

               /* Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();
                Log.Record_Detail__c=ex.getMessage();
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Exception_Type__c=ex.getTypeName();
                insert Log;*/
            }
        return new PageReference('javascript:window.close()');
    }
    
    public PageReference cancel() {
        return new PageReference('javascript:window.close()');
    }
}