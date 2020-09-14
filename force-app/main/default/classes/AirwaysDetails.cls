public class AirwaysDetails {
    public String s_date {get;set;}
    public String usrOpt {get;set;}
    public String countryName {get;set;}
    public String punjab {get;set;}
    
    public AirwaysDetails(){
		s_date = system.today().format();
    }
    public List<SelectOption> getuserOption(){
		List<SelectOption> slctOpt = new List<SelectOption>();
        slctOpt.add(new SelectOption('--None--','--None--'));
        slctOpt.add(new SelectOption('Domestic','Domestic'));
        slctOpt.add(new SelectOption('International','International'));
        return slctOpt;
    }
    public List<SelectOption> getinternational(){
		List<SelectOption> international = new List<SelectOption>();
        international.add(new SelectOption('--None--','--None--'));
        international.add(new SelectOption('UK','UK'));
        international.add(new SelectOption('USA','USA'));
        international.add(new SelectOption('CANADA','CANADA'));
        return international;
    }
    public List<SelectOption> getdomestic(){
		List<SelectOption> international = new List<SelectOption>();
        international.add(new SelectOption('Assam','Assam'));
        international.add(new SelectOption('Bihar','Bihar'));
        international.add(new SelectOption('West Bengal','West Bengal'));
        return international;
    }
    public List<SelectOption> getcountry(){
		List<SelectOption> country = new List<SelectOption>();
        System.debug('Hello');
        if(countryName == 'UK'){
        	country.add(new SelectOption('London','London'));
        	country.add(new SelectOption('**','**'));
        	country.add(new SelectOption('West Bengal','West Bengal'));
        }
        else if(countryName == 'USA'){
        	country.add(new SelectOption('Washington DC','Washington DC'));
        	country.add(new SelectOption('**','**'));
        	country.add(new SelectOption('West Bengal','West Bengal'));
        }else if(countryName == 'CANADA'){
        	country.add(new SelectOption('CALGARY','CALGARY'));
        	country.add(new SelectOption('**','**'));
        	country.add(new SelectOption('West Bengal','West Bengal'));
        }
        return country;
    }
    
}