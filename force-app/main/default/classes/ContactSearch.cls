public class ContactSearch {
    public static List<Contact> searchForContacts(String name, String mailingPostalCode){
        List<Contact> acc1 = new List<Contact>();
        acc1 = [SELECT Contact.Name from contact where LastName =: name And MailingPostalCode =: mailingPostalCode];
        System.debug(acc1);
        return acc1;
    }
}