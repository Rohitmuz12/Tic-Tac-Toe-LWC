public class AirwaysBookingsDetails {
    
    public String usrOpt{get;set;}
    public String sltdFlt{get;set;}
    public List<AirwaysSrcDes__c> selectedDetails {get;set;}
    public List<AirwaysSrcDes__c> selectedDetails1 {get;set;}
    public List<WrapBookingDetails> setsrcdesLst {get;set;}
    public Boolean displayPopUp {get;set;}
    public String firstName{get;set;}
    public String lastName{get;set;}
    public String age{get;set;}
    public String p_numbber{get;set;}
    public String Email_Id{get;set;}


    public AirwaysBookingsDetails(){
    }
    
    
    public List<SelectOption> getuserOption(){
        
        List<SelectOption> opt = new List<SelectOption>();
        opt.add(new SelectOption('--None--','--None--'));
        opt.add(new SelectOption('Domestic','Domestic'));
        opt.add(new SelectOption('International','International'));
        sltdFlt = '--None--';
        return opt;
    }
    
    public List<SelectOption> getflightList(){
        
        List<SelectOption> fltList = new List<SelectOption>();
        List<AirwaysDetails__c> details = [select Name, type__C from airwaysdetails__C];
        fltList.add(new SelectOption('--None--','--None--'));
        for(AirwaysDetails__c d: details){
            if(usrOpt == d.type__C){
                fltList.add(new SelectOption(d.Name,d.Name));
            }
        }
        return fltList;
        
    }
    public List<WrapBookingDetails> getsrcdesList(){
        List<AirwaysSrcDes__c> srcdesLst = [select name__r.name,name,starttime__C,endtime__C,SourceName__C,DesName__C from AirwaysSrcDes__C];
        setsrcdesLst = new List <WrapBookingDetails>();
        for(AirwaysSrcDes__c d: srcdesLst){
            if(sltdFlt == d.name__r.name){
                setsrcdesLst.add(new WrapBookingDetails(d));
            }
        }
        return setsrcdesLst;
    }
    
    public void processSelected(){
        System.debug('processSelected');
        selectedDetails = new List<AirwaysSrcDes__c>();
        //selectedDetails1 = Null;
        Integer flag = 0;
        for(WrapBookingDetails d: setsrcdesLst){
            if(d.selected == true){
                selectedDetails.add(d.details);
                flag = 1;
            }
            
            System.debug(d.details.name);
            System.debug(d.selected);
            System.debug('under loop');
            //selectedDetails1 = selectedDetails;
        }
        if(flag == 0){
            //selectedDetails1 = Null;
            selectedDetails = Null;
        }
    }
    
    public class WrapBookingDetails{
        public AirwaysSrcDes__C details {get;set;}
        public Boolean selected {get;set;}
        public WrapBookingDetails(AirwaysSrcDes__C d){
            details = d;
            selected = false;
        }
    }
    
    
    public PageReference processBooking(){
        PageReference pageRef;
        system.debug(firstName);
        system.debug(lastName);
        system.debug(age);
        system.debug(p_numbber);
        system.debug(Email_Id);
        List<Booking_C__c> bookDetails = new List<Booking_C__c>();
        bookDetails.add(new Booking_C__c(First_Name__c = firstName,Last_Name__c = lastName,Age__c = Integer.valueof(age), Phone_Number__c = p_numbber,Flight_ID__c = selectedDetails[0].name,
                                Flight_Name__c = selectedDetails[0].name__r.name,Email__c = Email_Id, Departure_Time__c = selectedDetails[0].StartTime__c, Arrival_Time__c = selectedDetails[0].EndTime__c,
                                Source__c = selectedDetails[0].SourceName__c,Destination__c = selectedDetails[0].DesName__c));
        try{
            insert bookDetails;
            pageRef = new PageReference('/apex/BookingDetails?id='+bookDetails[0].id);
        }catch(Exception e){
            System.debug(e);
        }
            return pageRef;
    }
}