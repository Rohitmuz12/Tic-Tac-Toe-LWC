@isTest
public class TestEmailManager {
    static testMethod void test1(){
        test.startTest();
        String[] s = new String[]{'rohitkrmuz00@gmail.com','rashmitchoudhary30@gmail.com'};
		EmailManager.sendMail(s,'check','checked');
        test.stopTest();
    }
}