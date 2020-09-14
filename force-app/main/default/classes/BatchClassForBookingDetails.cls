public class BatchClassForBookingDetails implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
    
        String query = 'SELECT Age__c,Arrival_Time__c,Departure_Time__c,Destination__c,Email__c,First_Name__c,Flight_ID__c,Flight_Name__c,Last_Name__c,Phone_Number__c,Source__c from Booking_C__c limit 1';
        
      return Database.getQueryLocator(query);
    }
   
   
    public void execute(Database.BatchableContext BC, List<Booking_C__c> scope){//hvh
        List<Booking_C__c> details = new List<Booking_C__c>();
       for(Booking_C__c b : scope){
           for(Integer i = 0; i < 100; i++ ){
               Booking_C__c details1 = new Booking_C__c();
               details1.First_Name__c = b.First_Name__c+i;
               details1.Last_Name__c = b.Last_Name__c+i;
               details1.Age__c = b.Age__c;
               details1.Phone_Number__c = b.Phone_Number__c+i;
               details1.Email__c = b.Email__c+i;
               details1.Flight_ID__c = b.Flight_ID__c;
               details1.Flight_Name__c = b.Flight_Name__c;
               details1.Source__c = b.Source__c;
               details1.Destination__c = b.Destination__c;
               details1.Arrival_Time__c = b.Arrival_Time__c;
               details1.Departure_Time__c = b.Departure_Time__c;
               details.add(details1);
           }
       }
       insert details;
    }
    
    public void finish(Database.BatchableContext BC){
       
    }

    
}