public with sharing class AccountTriggerHandler {

    public static void giveRecordAccess(List<Account> accounts){
        RecordSharingHandler.shareReadAccess(accounts);
    }
    
    public static void getChangedTeamRecords(Map<Id, Account> oldAccounts, List<Account> newAccounts){
        List<Account> changedTeamAccounts = new List<account>();
        
        for(Account newAccount: newAccounts){
            Account oldAccount = oldAccounts.get(newAccount.Id);
            
            if((newAccount.Team__c != oldAccount.Team__c) || (newAccount.OwnerId != oldAccount.OwnerId)){
                changedTeamAccounts.add(newAccount);
            }
        }
        
        if(!changedTeamAccounts.isEmpty()){
            RecordSharingHandler.shareReadAccess(changedTeamAccounts);
        }
    }
}