trigger AccountTrigger on Account (after insert, after update) {

    if(Trigger.isInsert){
        AccountTriggerHandler.giveRecordAccess(Trigger.new);
    }

    if(Trigger.isUpdate){
    
    }

}