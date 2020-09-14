public class BookingDetailsController {
    public Booking_C__c bookingDetails2 {get;set;}
    
    public BookingDetailsController() {
        getBookingDetails();
    }
    
    public List<Booking_C__c> getBookingDetails(){
        List<Booking_C__c> bookingDetails1 = [select First_Name__c,age__c,Last_Name__c,Phone_Number__c,Email__c,Flight_Name__c,Source__c,Destination__c,
        Departure_Time__c,Arrival_Time__c,Flight_ID__c from Booking_C__c
                where Id = :ApexPages.currentPage().getParameters().get('Id')];
        System.debug('Booking Details = '+bookingDetails1);
        bookingDetails2 = bookingDetails1[0];
        return bookingDetails1;
    }
    public void trigrForEmail(){
        bookingDetails2.For_Trigger__c = 1;
        try{
            update bookingDetails2;
        }catch(Exception e){
            System.debug(e);
        }
    }
    
    public void wrkFlwForEmail(){
        System.debug('Before Workflow');
        bookingDetails2.For_Workflow__c = 1;
        try{
            update bookingDetails2;
        }catch(Exception e){
            System.debug(e);
        }
        System.debug('After Workflow');
    }
    
    public void PDForEmail(){
        System.debug('Before Process Builder');
        bookingDetails2.For_Process_Builder__c = 1;
        try{
            update bookingDetails2;
        }catch(Exception e){
            System.debug(e);
        }
        System.debug('After Process Builder');
    }
}