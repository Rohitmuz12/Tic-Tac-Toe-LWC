public class PublishTicTacToeGameEvent {
    
    
    
    
    
    @AuraEnabled
    public static void joinGame(String receiverGameId,String playerName){
        List<TicTocEvent__e> TicTacToeEventList = new List<TicTocEvent__e>();
        TicTacToeEventList.add(new TicTocEvent__e(PlayerName__c = playerName,game_id__c = receiverGameId,action__c = 'join game'));
        
        List<Database.SaveResult> results = EventBus.publish(TicTacToeEventList);
        
        printDebugLogs(results);
    }
    
    @AuraEnabled
    public static void sendJoinConfirmation(String receiverGameId,string senderGameId,String playerName){
        List<TicTocEvent__e> TicTacToeEventList = new List<TicTocEvent__e>();
        TicTacToeEventList.add(new TicTocEvent__e(PlayerName__c = playerName,game_id__c = receiverGameId,SenderGameId__c = senderGameId,action__c = 'join confirmation'));
        
        List<Database.SaveResult> results = EventBus.publish(TicTacToeEventList);
        
        printDebugLogs(results);
    }
    
    @AuraEnabled
    public static void playMove(String cordinate,String senderId){
        List<TicTocEvent__e> TicTacToeEventList = new List<TicTocEvent__e>();
        TicTacToeEventList.add(new TicTocEvent__e(corditnate__c = cordinate,game_id__c = senderId,action__c = 'receiver move'));
        
        List<Database.SaveResult> results = EventBus.publish(TicTacToeEventList);
        
        printDebugLogs(results);
    }
    
    public static void printDebugLogs(List<Database.SaveResult> results){
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }       
        }
    }

}