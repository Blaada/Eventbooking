@isTest
public class TestDataFactory {
    public static Case createCase(String caseOrigin) {
        return new Case(Origin = caseOrigin, Subject = 'Event Booking', Description = 'Book Spots');
    }
    public static Case createCaseWithAccount(String caseOrigin, Integer numberOfContacts) {
        Account account = new Account(Name = 'Salesforce');
        insert account;
        createContacts(numberOfContacts, account);
        return new Case(Origin = caseOrigin, Subject = 'Event Booking', Description = 'Book Spots', AccountId = account.ID);
    }

    public static void createContacts(Integer numberOfContacts, Account account) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i=0;i<numberOfContacts;i++) {
            Contact contact = new Contact(LastName = 'Contact ' + i, AccountId = account.ID);
            contacts.add(contact);
        }
        insert contacts;
    }
}
