import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';

import publishJoinGame from '@salesforce/apex/PublishTicTacToeGameEvent.joinGame';

//Author Rasmit Kumar
export default class TicTacToePanel extends LightningElement {

    @api selectedChannel;
    isNoActiveGame = true;
    isCreateGame = false;
    isJoinAGame = false;
    isWaitingForJoining = false;
    playerName;
    waitingMsg = '';
    offLine = false;
    opponentName;

    //Show panel for create game
    createGame(){
        console.log('Create game called');
        this.isNoActiveGame = false;
        this.isCreateGame = true;
        this.waitingMsg = 'Your Game Id Please wait you will join soon!';
    }

    //After click on join button
    joinAGame(){
        this.isNoActiveGame = false;
        this.isJoinAGame = true;
        this.waitingMsg = 'Please wait you will join soon!';
    }

    get channelOptions(){
        return [
            {label : 'Play Online', value : 'online'},
            {label : 'Play n Pass', value : 'offline'}
        ];
    }

    //Toggle opponent name input field
    handleChannelOnchange(event){
        this.selectedChannel = event.target.value;
        if(this.selectedChannel === 'online')
            this.offLine = false;
        else
            this.offLine = true;
    }

    handleKeyUp(event){
        this.receiverGameId = event.target.value;
    }

    handlePlayerName(event){
        this.playerName = event.target.value;
    }

    handleOpponentName(event){
        this.opponentName = event.target.value;
    }

    //On click of start game with custom event for parent component
    startGame(){
        if(this.selectedChannel === undefined || this.selectedChannel === ''){
            this.showToastNotification('Please select game option.');
            return false;
        }

        if(this.playerName === undefined || this.playerName === ''){
            this.showToastNotification('Please enter player name.');
            return false;
        }

        const selectedEvent = new CustomEvent('startgame',{detail : {selectedChannel : this.selectedChannel,
                                playerName : this.playerName,opponentName : this.opponentName}});

        this.dispatchEvent(selectedEvent);
    }

    //Called from parent component
    @api waitForPlayer(gameId){
        this.waitingMsg = 'Your game id: '+gameId+ '\n Please wait for your teammate!';
        this.isWaitingForJoining = true;
        this.isCreateGame = false;
        this.isJoinAGame = false;
    }

    //After click on join button with game id and name.
    //Publishing join action with game id
    joinGame(){
        this.isWaitingForJoining = true;
        this.isJoinAGame = false;
        publishJoinGame({receiverGameId : this.receiverGameId,playerName : this.playerName})
        .then(data => {
            console.log(data)
        })
        .catch(error => {
            console.log(error);
        })
        const selectedEvent = new CustomEvent('joingame',{detail : { receiverGameId : this.receiverGameId,senderPlayerName : this.playerName}});

        this.dispatchEvent(selectedEvent);
        //Send receiver id and name.
    }

    showToastNotification(msg){
        const event = new ShowToastEvent({
            title: 'Warning',
            message: msg,
            variant : 'warning'
        });
        this.dispatchEvent(event);
    }
}