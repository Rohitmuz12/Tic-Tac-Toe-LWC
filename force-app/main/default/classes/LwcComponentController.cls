public with sharing class LwcComponentController{

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getAllContactsByAccountId(String accountId){

        return [select FirstName,LastName from contact where accountId =: accountId];

    }
}