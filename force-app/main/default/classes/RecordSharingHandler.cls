public with sharing class RecordSharingHandler {
    
    private static final String READ_ACCESS = 'Read';
    
    public static void shareReadAccess(List<account> accounts){
        List<Group> groups = getPublicGroups();
        Map<String, Group> groupsMap = getPublicGroupsMap(groups);
        List<Id> groupIds = getGroupIds(groups);
        List<Id> accountIds = getAccountIds(accounts);
        List<AccountShare> sharesToDelete = getAccountShares(accountIds, groupIds);
        
        Database.delete(sharesToDelete, false);
        
        List<AccountShare> shares = new List<AccountShare>();
        
        for(Account account: accounts){
            Group teamGroup = groupsMap.get(account.Team__c);
            AccountShare share = new AccountShare(AccountId = account.Id,
                                                  AccountAccessLevel = READ_ACCESS, 
                                                  UserOrGroupId = teamGroup.Id,
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
    
    public static List<Group> getPublicGroups(){
        List<String> teamNames = new List<String>();
        
        Schema.DescribeFieldResult fieldRes = Account.Team__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldRes.getPicklistValues();
        
        for(Schema.PicklistEntry en: entries){
            teamNames.add(en.getLabel());
        } 
        
        List<Group> groups = [SELECT Id, Name FROM group WHERE Name IN: teamNames];
        return groups;
    }
    
    public static Map<String, Group> getPublicGroupsMap(List<Group> groups){
        Map<String, Group> groupsMap = new Map<String, Group>();
        
        for(Group publicGroup: groups){
            groupsMap.put(publicGroup.Name, publicGroup);
            
        }
        
        return groupsMap;
    }
    
    public static List<Id> getAccountIds(List<Account> accounts){
        List<Id> accountIds = new List<Id>();
        for(Account account: accounts){
            accountIds.add(account.Id);
        }
        
        return accountIds;
    }
    
    public static List<Id> getGroupIds(List<Group> groups){
        List<Id> groupIds = new List<Id>();
        for(Group publicGroup: groups){
            groupIds.add(publicGroup.Id);
        }
        
        return groupIds;
    }
    
    public static List<AccountShare> getAccountShares(List<Id> accountIds, List<Id> groupIds){
        return [SELECT Id, AccountId, AccountAccessLevel, UserOrGroupId, OpportunityAccessLevel, CaseAccessLevel
                FROM AccountShare WHERE AccountId IN: accountIds
                AND UserOrGroupId IN: groupIds];
    }
}