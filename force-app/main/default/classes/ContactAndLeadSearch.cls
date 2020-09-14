public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String srch){
        List<List<SObject>> srchList = [FIND :srch IN ALL FIELDS 
                                        RETURNING Contact(FirstName,LastName,Department), Lead(FirstName,LastName)];
        System.debug(srchList);
        return srchList;
    }
}