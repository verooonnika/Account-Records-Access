public with sharing class RecordSharingHandler {

    private static final String READ_ACCESS = 'Read';
    
    public static List<Group> getPublicGroups(){
        return [SELECT Id, Name FROM group];
    }
    
    public static void shareReadAccess(List<account> accounts){
        List<Group> groups = getPublicGroups();
        List<AccountShare> shares = new List<AccountShare>();
        
        for(Account account: accounts){
            for(Group publicGroup: groupes){
                if(account.Team__c = publicGroup.Name){
                    AccountShare share  = new AccountShare(AccountId = account.Id,
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
}