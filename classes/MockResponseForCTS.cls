@isTest
global class MockResponseForCTS implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) { 
    	 HttpResponse res = new HttpResponse();
    	 res.setHeader('Content-Type', 'application/json');
    	 res.setStatusCode(200);
       system.debug('INSIDE MOCK CLASS--');
        if(req.getEndpoint().contains('getAvailableNDateTimeSlotsStartFromDateWithSecondaryResourcesResponse'))
            res.setBody('(dateTimeSlot:[apex_schema_type_info=(http://services.timecommerce.timetrade.com/ws, false, false), appointmentSlotTime=2017-01-24T14:00:00.000Z, appointmentSlotTime_type_info=(appointmentSlotTime, http://services.timecommerce.timetrade.com/ws, null, 0, 1, false), field_order_type_info=(appointmentSlotTime, lengthinMin, resourceExternalIds, secondaryResourcePool, slotStatus), lengthinMin=30, lengthinMin_type_info=(lengthinMin, http://services.timecommerce.timetrade.com/ws, null, 1, 1, false), resourceExternalIds=(kgupta@timetrade.com), resourceExternalIds_type_info=(resourceExternalIds, http://services.timecommerce.timetrade.com/ws, null, 0, -1, true), secondaryResourcePool=null, secondaryResourcePool_type_info=(secondaryResourcePool, http://services.timecommerce.timetrade.com/ws, null, 0, -1, true), slotStatus=Available, slotStatus_type_info=(slotStatus, http://services.timecommerce.timetrade.com/ws, null, 0, 1, false)])');

        return res;
    }
}