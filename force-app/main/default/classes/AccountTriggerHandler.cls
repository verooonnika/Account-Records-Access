public with sharing class AccountTriggerHandler {

    public static void giveRecordAccess(List<Account> accounts){
        RecordSharingHandler.shareReadAccess(accounts);

    }
}
