public class TTConfigurationWS {
    
    public class TTStatus {
        public String cause;
        public String result;
        public Integer status;
        private String[] cause_type_info = new String[]{'cause','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] result_type_info = new String[]{'result','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] status_type_info = new String[]{'status','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'cause','result','status'};
    }

    public class copyResourceDeep {
        public String sourceLocationExternalId;
        public String sourceResourceExternalId;
        public String targetLocationExternalId;
        public String targetResourceExternalId;
        private String[] sourceLocationExternalId_type_info = new String[]{'sourceLocationExternalId','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] sourceResourceExternalId_type_info = new String[]{'sourceResourceExternalId','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] targetLocationExternalId_type_info = new String[]{'targetLocationExternalId','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] targetResourceExternalId_type_info = new String[]{'targetResourceExternalId','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'sourceLocationExternalId','sourceResourceExternalId','targetLocationExternalId','targetResourceExternalId'};
    }
    
    public class copyResourceDeepResponse {
        public TTConfigurationWS.TTStatus return_x;
        private String[] return_x_type_info = new String[]{'return','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    
    public class updateInsertResourceResponse {
        public TTConfigurationWS.TTStatus return_x;
        private String[] return_x_type_info = new String[]{'return','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    
    public class updateInsertResource {
        public TTConfigurationServices.resource resource;
        private String[] resource_type_info = new String[]{'resource','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'resource'};
    }
    
    public class getResourceByExternalId {
        public String locationExternalId;
        public String resourceExternalId;
        private String[] locationExternalId_type_info = new String[]{'locationExternalId','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] resourceExternalId_type_info = new String[]{'resourceExternalId','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'locationExternalId','resourceExternalId'};
    }
    
    public class getResourceByExternalIdResponse {
        public TTConfigurationServices.resource return_x;
        private String[] return_x_type_info = new String[]{'return','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    
    public class monthlySubSchedule {
        public TTConfigurationWS.monthlySubSchedulePeriod[] monthlySubSchedulePeriods;
        private String[] monthlySubSchedulePeriods_type_info = new String[]{'monthlySubSchedulePeriods','http://services.timecommerce.timetrade.com/ws',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'monthlySubSchedulePeriods'};
    }
    
    public class oneTimeSubSchedule {
        public TTConfigurationWS.oneTimeSubSchedulePeriod[] oneTimeSubSchedulePeriods;
        private String[] oneTimeSubSchedulePeriods_type_info = new String[]{'oneTimeSubSchedulePeriods','http://services.timecommerce.timetrade.com/ws',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'oneTimeSubSchedulePeriods'};
    }
    
    public class weeklySubSchedule {
        public TTConfigurationWS.weeklySubSchedulePeriod[] weeklySubSchedulePeriods;
        private String[] weeklySubSchedulePeriods_type_info = new String[]{'weeklySubSchedulePeriods','http://services.timecommerce.timetrade.com/ws',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'weeklySubSchedulePeriods'};
    }
    
    public class yearlySubSchedulePeriod {
        public Integer schedulePeriodId;
        public Integer dayOfMonth;
        public DateTime endTime;
        public String month;
        public String scheduleAvailabilityType;
        public DateTime startTime;
        private String[] schedulePeriodId_type_info = new String[]{'schedulePeriodId','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] dayOfMonth_type_info = new String[]{'dayOfMonth','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] endTime_type_info = new String[]{'endTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] month_type_info = new String[]{'month','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] scheduleAvailabilityType_type_info = new String[]{'scheduleAvailabilityType','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] startTime_type_info = new String[]{'startTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'schedulePeriodId','dayOfMonth','endTime','month','scheduleAvailabilityType','startTime'};
    }
    
    public class yearlySubSchedule {
        public TTConfigurationWS.yearlySubSchedulePeriod[] yearlySubSchedulePeriods;
        private String[] yearlySubSchedulePeriods_type_info = new String[]{'yearlySubSchedulePeriods','http://services.timecommerce.timetrade.com/ws',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'yearlySubSchedulePeriods'};
    }
    
    public class activityRules {
        public Boolean allocateSamePrimaryResource;
        public Boolean allocateSameSecondaryResource;
        public Boolean allowConcurrentAppointments;
        public Boolean applyDateRange;
        public Boolean canSchedulePartialSeries;
        public Boolean canScheduleSingleEvents;
        public Boolean isEventSeries;
        public Boolean isOverbookingEnabled;
        public Boolean isPaymentEnabled;
        public Integer maxAttendeesPerAppointment;
        public String overBookingRule;
        public Boolean repeatQuestionForAttendees;
        public String resourceAllocationRule;
        private String[] allocateSamePrimaryResource_type_info = new String[]{'allocateSamePrimaryResource','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] allocateSameSecondaryResource_type_info = new String[]{'allocateSameSecondaryResource','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] allowConcurrentAppointments_type_info = new String[]{'allowConcurrentAppointments','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] applyDateRange_type_info = new String[]{'applyDateRange','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] canSchedulePartialSeries_type_info = new String[]{'canSchedulePartialSeries','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] canScheduleSingleEvents_type_info = new String[]{'canScheduleSingleEvents','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] isEventSeries_type_info = new String[]{'isEventSeries','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] isOverbookingEnabled_type_info = new String[]{'isOverbookingEnabled','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] isPaymentEnabled_type_info = new String[]{'isPaymentEnabled','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] maxAttendeesPerAppointment_type_info = new String[]{'maxAttendeesPerAppointment','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] overBookingRule_type_info = new String[]{'overBookingRule','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] repeatQuestionForAttendees_type_info = new String[]{'repeatQuestionForAttendees','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] resourceAllocationRule_type_info = new String[]{'resourceAllocationRule','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'allocateSamePrimaryResource','allocateSameSecondaryResource','allowConcurrentAppointments','applyDateRange','canSchedulePartialSeries','canScheduleSingleEvents','isEventSeries','isOverbookingEnabled','isPaymentEnabled','maxAttendeesPerAppointment','overBookingRule','repeatQuestionForAttendees','resourceAllocationRule'};
    }
    
    public class activityDuration {
        public String displayName;
        public Integer durationInMinutes;
        private String[] displayName_type_info = new String[]{'displayName','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] durationInMinutes_type_info = new String[]{'durationInMinutes','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'displayName','durationInMinutes'};
    }
    
    public class suppressVisibilityPerApp {
        public Integer appId;
        public String appName;
        public Boolean suppressed;
        private String[] appId_type_info = new String[]{'appId','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] appName_type_info = new String[]{'appName','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] suppressed_type_info = new String[]{'suppressed','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'appId','appName','suppressed'};
    }
    
    public class address {
        public String address1;
        public String address2;
        public String city;
        public String country;
        public String postalCode;
        public String state;
        public String countryCode;
        private String[] address1_type_info = new String[]{'address1','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] address2_type_info = new String[]{'address2','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] city_type_info = new String[]{'city','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] country_type_info = new String[]{'country','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] postalCode_type_info = new String[]{'postalCode','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] state_type_info = new String[]{'state','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] countryCode_type_info = new String[]{'countryCode','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'address1','address2','city','country','postalCode','state','countryCode'};
    }
    
    public class emailAddressData {
        public String emailAddress;
        public Boolean emailEnabled;
        public String emailFormatType;
        public String emailName;
        private String[] emailAddress_type_info = new String[]{'emailAddress','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] emailEnabled_type_info = new String[]{'emailEnabled','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] emailFormatType_type_info = new String[]{'emailFormatType','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] emailName_type_info = new String[]{'emailName','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'emailAddress','emailEnabled','emailFormatType','emailName'};
    }
    
    public class phoneData {
        public String fax;
        public String faxExt;
        public String homePhone;
        public String homePhoneExt;
        public String mobile;
        public String mobileExt;
        public String workPhone;
        public String workPhoneExt;
        private String[] fax_type_info = new String[]{'fax','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] faxExt_type_info = new String[]{'faxExt','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] homePhone_type_info = new String[]{'homePhone','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] homePhoneExt_type_info = new String[]{'homePhoneExt','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] mobile_type_info = new String[]{'mobile','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] mobileExt_type_info = new String[]{'mobileExt','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] workPhone_type_info = new String[]{'workPhone','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] workPhoneExt_type_info = new String[]{'workPhoneExt','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'fax','faxExt','homePhone','homePhoneExt','mobile','mobileExt','workPhone','workPhoneExt'};
    }
    
    public class resourceRules {
        public Boolean allowConcurrentActivities;
        public Boolean allowScheduleExpansion;
        public Boolean applyAppointmentsAcrossLocations;
        public Boolean applyConcurrentAppointments;
        public Boolean applyRecoveryOnTravel;
        public Boolean applyTimezone;
        public Boolean applyTravelTime;
        public Boolean overlapSetupTravelTime;
        public Integer scheduleExpansionLength;
        private String[] allowConcurrentActivities_type_info = new String[]{'allowConcurrentActivities','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] allowScheduleExpansion_type_info = new String[]{'allowScheduleExpansion','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] applyAppointmentsAcrossLocations_type_info = new String[]{'applyAppointmentsAcrossLocations','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] applyConcurrentAppointments_type_info = new String[]{'applyConcurrentAppointments','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] applyRecoveryOnTravel_type_info = new String[]{'applyRecoveryOnTravel','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] applyTimezone_type_info = new String[]{'applyTimezone','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] applyTravelTime_type_info = new String[]{'applyTravelTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] overlapSetupTravelTime_type_info = new String[]{'overlapSetupTravelTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] scheduleExpansionLength_type_info = new String[]{'scheduleExpansionLength','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'allowConcurrentActivities','allowScheduleExpansion','applyAppointmentsAcrossLocations','applyConcurrentAppointments','applyRecoveryOnTravel','applyTimezone','applyTravelTime','overlapSetupTravelTime','scheduleExpansionLength'};
    }
    
    public class geoCoordinates {
        public Double latitude;
        public Double longitude;
        private String[] latitude_type_info = new String[]{'latitude','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] longitude_type_info = new String[]{'longitude','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'latitude','longitude'};
    }
    
    public class monthlySubSchedulePeriod {
        public Integer schedulePeriodId;
        public Integer dayOfMonth;
        public DateTime endTime;
        public String scheduleAvailabilityType;
        public DateTime startTime;
        private String[] schedulePeriodId_type_info = new String[]{'schedulePeriodId','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] dayOfMonth_type_info = new String[]{'dayOfMonth','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] endTime_type_info = new String[]{'endTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] scheduleAvailabilityType_type_info = new String[]{'scheduleAvailabilityType','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] startTime_type_info = new String[]{'startTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'schedulePeriodId','dayOfMonth','endTime','scheduleAvailabilityType','startTime'};
    }
    public class oneTimeSubSchedulePeriod {
        public Integer schedulePeriodId;
        public DateTime endTime;
        public String scheduleAvailabilityType;
        public DateTime startTime;
        private String[] schedulePeriodId_type_info = new String[]{'schedulePeriodId','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] endTime_type_info = new String[]{'endTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] scheduleAvailabilityType_type_info = new String[]{'scheduleAvailabilityType','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] startTime_type_info = new String[]{'startTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'schedulePeriodId','endTime','scheduleAvailabilityType','startTime'};
    }
    
    public class weeklySubSchedulePeriod {
        public Integer schedulePeriodId;
        public DateTime endTime;
        public String scheduleAvailabilityType;
        public DateTime startTime;
        public String weekDay;
        public String localStartTime;
        public String localEndTime;
        private String[] schedulePeriodId_type_info = new String[]{'schedulePeriodId','http://services.timecommerce.timetrade.com/ws',null,'1','1','false'};
        private String[] endTime_type_info = new String[]{'endTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] scheduleAvailabilityType_type_info = new String[]{'scheduleAvailabilityType','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] startTime_type_info = new String[]{'startTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] weekDay_type_info = new String[]{'weekDay','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] localStartTime_type_info = new String[]{'localStartTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] localEndTime_type_info = new String[]{'localEndTime','http://services.timecommerce.timetrade.com/ws',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://services.timecommerce.timetrade.com/ws','false','false'};
        private String[] field_order_type_info = new String[]{'schedulePeriodId','endTime','scheduleAvailabilityType','startTime','weekDay','localStartTime','localEndTime'};
    }
    
    
    
    public class ConfigurationWS {
        public String endpoint_x = 'https://api-sale.timetradesystems.com:443/tc/api/7.0/ConfigurationServices';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        public Security_element Security;
        private String Security_hns = 'Security=http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
        public void SetSecurity(String userid, String password) {
                     Security = new Security_element(userid,password);
        }
        public void SetEndPoint(String endpoint) {
                     endpoint_x = endpoint;
        }
        private String[] ns_map_type_info = new String[]{'http://services.timecommerce.timetrade.com/configuration', 'TTConfigurationServices', 'http://services.timecommerce.timetrade.com/ws', 'TTConfigurationWS'};
        
        
        public TTConfigurationWS.TTStatus copyResourceDeep(String sourceLocationExternalId,String sourceResourceExternalId,String targetLocationExternalId,String targetResourceExternalId) {
            TTConfigurationWS.copyResourceDeep request_x = new TTConfigurationWS.copyResourceDeep();
            request_x.sourceLocationExternalId = sourceLocationExternalId;
            request_x.sourceResourceExternalId = sourceResourceExternalId;
            request_x.targetLocationExternalId = targetLocationExternalId;
            request_x.targetResourceExternalId = targetResourceExternalId;
            TTConfigurationWS.copyResourceDeepResponse response_x;
            Map<String, TTConfigurationWS.copyResourceDeepResponse> response_map_x = new Map<String, TTConfigurationWS.copyResourceDeepResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://services.timecommerce.timetrade.com/ws',
              'copyResourceDeep',
              'http://services.timecommerce.timetrade.com/ws',
              'copyResourceDeepResponse',
              'TTConfigurationWS.copyResourceDeepResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        
        public TTConfigurationWS.TTStatus updateInsertResource(TTConfigurationServices.resource resource) {
            TTConfigurationWS.updateInsertResource request_x = new TTConfigurationWS.updateInsertResource();
            request_x.resource = resource;
            TTConfigurationWS.updateInsertResourceResponse response_x;
            Map<String, TTConfigurationWS.updateInsertResourceResponse> response_map_x = new Map<String, TTConfigurationWS.updateInsertResourceResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://services.timecommerce.timetrade.com/ws',
              'updateInsertResource',
              'http://services.timecommerce.timetrade.com/ws',
              'updateInsertResourceResponse',
              'TTConfigurationWS.updateInsertResourceResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        
        public TTConfigurationServices.resource getResourceByExternalId(String locationExternalId,String resourceExternalId) {
            TTConfigurationWS.getResourceByExternalId request_x = new TTConfigurationWS.getResourceByExternalId();
            request_x.locationExternalId = locationExternalId;
            request_x.resourceExternalId = resourceExternalId;
            TTConfigurationWS.getResourceByExternalIdResponse response_x;
            Map<String, TTConfigurationWS.getResourceByExternalIdResponse> response_map_x = new Map<String, TTConfigurationWS.getResourceByExternalIdResponse>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://services.timecommerce.timetrade.com/ws',
              'getResourceByExternalId',
              'http://services.timecommerce.timetrade.com/ws',
              'getResourceByExternalIdResponse',
              'TTConfigurationWS.getResourceByExternalIdResponse'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        
        
    }
    
    public class Security_element{
             
              public Security_element(String username, String password) {
             
                     usernameToken = new UsernameToken_element(username,password);
                    
              }
              public UsernameToken_element usernameToken;
              private String[] usernameToken_type_info = new String[]{'UsernameToken','http://www.w3.org/2001/XMLSchema','element','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','true','false'};
        private String[] field_order_type_info = new String[]{'usernameToken'};
       
       }
    public class UsernameToken_element {
             
              public UsernameToken_element(String username, String password) {
             
                     this.username = username;
                     this.password = password;
             
              }
             
        public String username;
              public String password;
        private String[] username_type_info = new String[]{'Username','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] password_type_info = new String[]{'Password','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd','true','false'};
        private String[] field_order_type_info = new String[]{'username','password'};
    }
}