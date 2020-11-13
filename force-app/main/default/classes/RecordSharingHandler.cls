public with sharing class RecordSharingHandler {

    private static final String READ_ACCESS = 'Read';
    
    public static Id searchPublicGroup(String groupName){
        Group publicGroup = [SELECT Id, Name FROM group WHERE Name =: groupName LIMIT 1];
        return publicgroup.Id;
    }
    
    public static void shareReadAccess(List<account> accounts){
        List<AccountShare> shares = new List<AccountShare>();
        
        for(Account account: accounts){
            Id groupId = searchPublicGroup(account.Team__c);
            
            AccountShare share  = new AccountShare(AccountId = account.Id,
                                                   AccountAccessLevel = READ_ACCESS, 
                                                   UserOrGroupId = groupId,
                                                   OpportunityAccessLevel = READ_ACCESS,
                                                   CaseAccessLevel = READ_ACCESS );
            
            shares.add(share);
        }
        
        List<Database.SaveResult> saveResults = Database.insert(shares, false);
        
        for (Database.SaveResult sr : saveResults) {
            if (sr.isSuccess()) {
                System.debug('Records successfully shared');
            }
        }
    }
}