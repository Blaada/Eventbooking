/**
 * @author YOUSSEF BLAADA (yblaada@salesforce.com)
 * @date 18 mar 2022
 *
 * @description External System Service, calls an external service with a Contact using ExternalSystemCallout class.
 *
 */
public without sharing class ExternalSystemService {
    /**
     * @description get accounts and send them to ExternalSystemCallout class for processing.
     * @param handledCase Handled case
     */
    public void registerAttendees(Case handledCase){
        if(!Schema.sObjectType.Account.isQueryable()){
            return;
        }
        List<Account> accounts = [SELECT id FROM Account where id = :handledCase.AccountId];
        Set<Id> accountIdsSet = (new Map<Id,SObject>(accounts)).keySet();
        ExternalSystemCallout.makeCallout(accountIdsSet, handledCase.Id);
    } 
}