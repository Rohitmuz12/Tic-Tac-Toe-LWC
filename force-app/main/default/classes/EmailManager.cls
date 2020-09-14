public class EmailManager {
    
    public static void sendMail(String[] address, String subject, String body){
        Messaging.SingleEmailMessage mail = new  Messaging.SingleEmailMessage();
            mail.setToAddresses(address);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        
        inspectResults(results);
    }
    
    private static Boolean inspectResults(Messaging.SendEmailResult[] results){
        
        Boolean sendResult = true;
        
        for(Messaging.SendEmailResult res : results){
            if(res.isSuccess()){
                System.debug('Email sent sucessfully');
            }
            else{
                sendResult = false;
                System.debug('The following error occured '+res.getErrors());
            }
        }
        
        return sendResult;
        
    }
}