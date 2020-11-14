public with sharing class RecordSharingHandler {
    
    private static final String READ_ACCESS = 'Read';
    
    public static void shareReadAccess(List<account> accounts){
        List<Group> groups = getPublicGroups();
        List<Id> accountIds = getAccountIds(accounts);
        List<AccountShare> sharesToDelete = getAccountShares(accountIds);
        
        Database.delete(sharesToDelete, false);
        
        List<AccountShare> shares = new List<AccountShare>();
        
        for(Account account: accounts){
            for(Group publicGroup: groups){
                if(account.Team__c == publicGroup.Name){
                    AccountShare share = new AccountShare(AccountId = account.Id,
                                                          AccountAccessLevel = READ_ACCESS, 
                                                          UserOrGroupId = publicGroup.Id,
                                                          OpportunityAccessLevel = READ_ACCESS,
                                                          CaseAccessLevel = READ_ACCESS );
                    
                    shares.add(share);
                }
            }            
        }
        
        List<Database.SaveResult> saveResults = Database.insert(shares, false);
        
        for (Database.SaveResult sr : saveResults) {
            if (sr.isSuccess()) {
                System.debug('Records successfully shared');
            }
        }
    }
    
    public static List<Group> getPublicGroups(){
        return [SELECT Id, Name FROM group];
    }
    
    public static List<Id> getAccountIds(List<Account> accounts){
        List<Id> accountIds = new List<Id>();
        for(Account account: accounts){
            accountIds.add(account.Id);
        }
        
        return accountIds;
    }
    
    public static List<AccountShare> getAccountShares(List<Id> accountIds){
        return [SELECT Id, AccountId, AccountAccessLevel, UserOrGroupId, OpportunityAccessLevel, CaseAccessLevel FROM AccountShare WHERE AccountId IN: accountIds];
    }
}