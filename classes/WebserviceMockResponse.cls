@isTest 
global class WebserviceMockResponse implements WebServiceMock   {
    global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
             
                TTAppointmentWS.getAvailableNDateTimeSlotsStartFromDateResponse response_x = new TTAppointmentWS.getAvailableNDateTimeSlotsStartFromDateResponse();
                response_x.return_x = new List<TTAppointmentWS.dateTimeSlot>();
              
               TTAppointmentWS.dateTimeSlot Response1=new TTAppointmentWS.dateTimeSlot();
               Response1.appointmentSlotTime=String.valueOf(System.now());
               Response1.lengthinMin=30;               
               Response1.resourceExternalIds=new List<String>{'test@timetrade.com'};
               response_x.return_x .add(Response1);
               
               TTAppointmentWS.dateTimeSlot Response2=new TTAppointmentWS.dateTimeSlot();
               Response1.appointmentSlotTime=String.valueOf(System.now().addMonths(1));
               Response1.lengthinMin=30;               
               Response1.resourceExternalIds=new List<String>{'test@timetrade.com'};
               response_x.return_x .add(Response2);
               
               TTAppointmentWS.dateTimeSlot Response3=new TTAppointmentWS.dateTimeSlot();
               Response1.appointmentSlotTime=String.valueOf(System.now().addMonths(-1));
               Response1.lengthinMin=30;               
               Response1.resourceExternalIds=new List<String>{'test@timetrade.com'};
               response_x.return_x .add(Response3);    
              // response_x.return_x = return_x;
               System.debug('response_x is--'+response_x);
               response.put('response_x',response_x);
               
               //return Response1;
               System.debug('INSIDE MOCK');
           }
}