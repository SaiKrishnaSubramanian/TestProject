public class Ctrl_CreateMeetingInvitationTemplate {
    public Invitation_Template__c CurrentTemplate{get;set;}    
    public String UserName {get;set;}
    public String SelectedFolder{get;set;}    
    public String InvitationTemplate{get;set;}  
    public String ConfirmationTemplate{get;set;} 
    public String ModificationTemplate{get;set;} 
    public String CancelTemplate{get;set;} 
    public String CompletionTemplate{get;set;} 
    public String NoShowTemplate{get;set;} 
    public String ReminderTemplate{get;set;} 
    private Folder emailFolder;
    public boolean isException;
    public Map<String,ID> MapOfFolderNameToFolderID;
    public Map<ID,List<EmailTemplate>> MapOfFolderToTemplateList;
    public List<SelectOption> FolderNames {get;set;}
    public List<SelectOption> TemplateNames {get;set;}
    private ApexPages.StandardController stdController;
    public Ctrl_CreateMeetingInvitationTemplate(ApexPages.StandardController controller) {
        isException = false;
        this.stdController=controller; 
        MapOfFolderNameToFolderID=new Map<String,ID>();
        FolderNames = new List<SelectOption>();
        TemplateNames = new List<SelectOption>();
        UserName=UserInfo.getName();   
        MapOfFolderToTemplateList=new Map<ID,List<EmailTemplate>>();
        
        if(stdController.getID()==null)
        CurrentTemplate =  new Invitation_Template__c();
        
        else {
            List<Invitation_Template__c> listOfInvitationTemplates = new List<Invitation_Template__c>([select Id, Name, Cancel_Template_Unique_Name__c,Completion_Template_Unique_Name__c,Confirmation_Template_Unique_Name__c,Invitation_Template__c,Modification_Template_Unique_Name__c,NoShow_Template_Unique_Name__c,Reminder_Template_Unique_Name__c,Send_Cancelation_Email__c,Send_Completion_Email__c,Send_Confirmation_Email__c,Send_Modification_Email__c,Send_NoShow_Email__c,Send_Reminder_Email__c,Outlook_Invite__c from Invitation_Template__c where Id=: stdController.getID()]);
            if(!listOfInvitationTemplates.isEmpty())
                CurrentTemplate = listOfInvitationTemplates[0];

            InvitationTemplate=CurrentTemplate.Invitation_Template__c;
            ConfirmationTemplate=CurrentTemplate.Confirmation_Template_Unique_Name__c;
            ModificationTemplate=CurrentTemplate.Modification_Template_Unique_Name__c;
            CancelTemplate=CurrentTemplate.Cancel_Template_Unique_Name__c;
            CompletionTemplate=CurrentTemplate.Completion_Template_Unique_Name__c;
            NoShowTemplate=CurrentTemplate.NoShow_Template_Unique_Name__c;
            ReminderTemplate=CurrentTemplate.Reminder_Template_Unique_Name__c;    
        }
            
        
        
        EmailTemplate[] TempList=[SELECT Name,ID,folderid,Developername FROM EmailTemplate];        
      
        for(EmailTemplate temp:TempList) {
            if(MapOfFolderToTemplateList.containsKey(temp.folderid))
                MapOfFolderToTemplateList.get(temp.folderid).add(temp);
            else
                MapOfFolderToTemplateList.put(temp.folderid,new List<EmailTemplate>{temp});
        }
        
        
        populateFolderNames();
        populateTemplateNames();
    }
    
    public void populateFolderNames() {
       
        emailFolder = [SELECT Id, Name,Type FROM  Folder WHERE Type = 'Email' and Developername = 'TimeTrade_Emails'];
        
        /*for(Folder Temp:FolderList) {
           FolderNames.add(new SelectOption(Temp.Name,Temp.Name)); 
           String compKey=Temp.Name+'-'+Temp.Type;
           MapOfFolderNameToFolderID.put(compKey,Temp.ID);
        }
        
        if(FolderNames.size()==0)
            FolderNames.add(new SelectOption('', '--None--'));*/
        
            
        
        
    }
    public void populateTemplateNames() {
        TemplateNames=new List<SelectOption>(); 
        TemplateNames.add(new SelectOption('', '--None--'));
        String compKey=SelectedFolder+'-'+'Email';       
        List<EmailTemplate> TempList=new  List<EmailTemplate>([select Id, Name, Developername from EmailTemplate where FolderId =: emailFolder.Id ]);
        
        /*if(MapOfFolderNameToFolderID.containsKey(compKey)) {
              if(MapOfFolderToTemplateList.containsKey(MapOfFolderNameToFolderID.get(compKey)))
                 TempList=MapOfFolderToTemplateList.get(MapOfFolderNameToFolderID.get(compKey));
        }*/
      
        
        for(EmailTemplate temp:TempList) {
            TemplateNames.add(new SelectOption(Temp.Developername,Temp.Name));
        }
        
    }
    public PageReference saverec() {
        
        try {
        if(isException && Test.isRunningTest()){
                    Integer i = 1/0;
                }
        if(InvitationTemplate==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Invitation_Template_Unique_Name_Missing));    
            return null;
        }
             
        CurrentTemplate.Invitation_Template__c=InvitationTemplate;
        CurrentTemplate.Confirmation_Template_Unique_Name__c=ConfirmationTemplate;
        CurrentTemplate.Modification_Template_Unique_Name__c=ModificationTemplate;
        CurrentTemplate.Cancel_Template_Unique_Name__c=CancelTemplate;
        CurrentTemplate.Completion_Template_Unique_Name__c=CompletionTemplate;
        CurrentTemplate.NoShow_Template_Unique_Name__c=NoShowTemplate;
        CurrentTemplate.Reminder_Template_Unique_Name__c=ReminderTemplate;
        
        if(CurrentTemplate != null){
            upsert CurrentTemplate;
            PageReference pg = new PageReference('/'+CurrentTemplate.Id);
            pg.setRedirect(true);
            return pg;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.Label.Invitation_Template_Error_In_Record_Creation));
            return null;
        }
             
        /*Database.UpsertResult srList = Database.upsert(CurrentTemplate, false);
            
            if(srList.isSuccess()) {
                PageReference pg = new PageReference('/'+CurrentTemplate.Id);
                pg.setRedirect(true);
                return pg;  
            }
            else {
                if(InvitationTemplate==null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field missing:Invitation Template Unique Name'));    
                else
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was an error in saving the record.Please try again.'));
                 return null;
            }*/
        }
      
        catch(Exception ex) {
            //Insert Debug Log object whenever there is an error
            ExceptionHandler.InsertDebugLog(ex.getLineNumber(),null,ex.getStackTraceString(),ex.getMessage(),ex.getTypeName());

              /*  Debug_Log__c Log=new Debug_Log__c();
                Log.Line_Number__c=ex.getLineNumber();              
                Log.Error_Description__c=ex.getStackTraceString();
                Log.Error_Message__c=ex.getMessage();
                Log.Exception_Type__c=ex.getTypeName();
                insert Log;*/
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));    
                
            return null;
        }


               
    }
    public PageReference saveandnew() {
        saverec();
        
        PageReference redirectPage = Page.CreateMeetingInvitationTemplate;
        redirectPage.setRedirect(true);
        return redirectPage;
       
    }
    public PageReference cancelrec() {
        Schema.DescribeSObjectResult result = Invitation_Template__c.SObjectType.getDescribe(); 
        PageReference pageRef = new PageReference('/' + result.getKeyPrefix()+'/o'); 
        pageRef.setRedirect(true); 
        return pageRef; 
        
    }
}