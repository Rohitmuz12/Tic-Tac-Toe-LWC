public class AccountHandler {
    public static Account insertNewAccount(String str){
        Account acc = new Account(Name = str);
        try{
        	insert acc;
            System.debug('record sucessfully inserted');
            return acc;
        }catch(DmlException e){
            System.debug('record not inserted');
            return null;
        }
    }
}