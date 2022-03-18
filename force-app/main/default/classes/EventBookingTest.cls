@isTest
public class EventBookingTest {  

        @isTest
        public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            // Given
    
            Case phoneCase = TestDataFactory.createCase('Phone');
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(phoneCase, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess(), 'Case should not be created.');
            System.assert(result.getErrors().size() > 0, 'There is no errors occured while creating this Case.');
            System.assertEquals('You cannot create a request without attaching an account',
            result.getErrors()[0].getMessage(), 'Case does not contain the specified error message.');
        }
        
        @isTest
        public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){
            // Given

            Case phoneCaseWithAccount = TestDataFactory.createCaseWithAccount('Phone', 0);

            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(phoneCaseWithAccount, false);

            Test.stopTest();

            // Then

            System.assert(!result.isSuccess(),'Case should not be created.');
            System.assert(result.getErrors().size() > 0, 'There is no errors occured while creating this Case.');
            System.assertEquals('You cannot create a request for accounts without contacts',
            result.getErrors()[0].getMessage(), 'Case does not contain the specified error message.');
        }
        
        @isTest
        public static void bookEventFromPhone(){
            // Given
            
            Case phoneCaseWithAccountContacts = TestDataFactory.createCaseWithAccount('Phone', 3);        
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(phoneCaseWithAccountContacts, false);
            Test.stopTest();

            // Then

            System.assert(result.isSuccess(), 'Case creation should be successful');


        }


        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // Given
            
            Case phoneCaseWithAccountContacts = TestDataFactory.createCaseWithAccount('Phone', 4);
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(phoneCaseWithAccountContacts, false);

            Test.stopTest();

            // Then
            System.assert(!result.isSuccess(), 'Case should not be created.');
            System.assert(result.getErrors().size() > 0, 'There is no errors occured while creating this Case.');
            System.assertEquals('Phone request are only allowed to have three attendee',
            result.getErrors()[0].getMessage(), 'Case does not contain the specified error message.');

        }
        
        @isTest
        public static void bookEventFromTheWeb(){
            // Given
            
            Case phoneCaseWithAccountContacts = TestDataFactory.createCaseWithAccount('Web', 1);
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(phoneCaseWithAccountContacts, false);

            Test.stopTest();

            // Then

            System.assert(result.isSuccess(), 'Case creation should successful.');

                
        } 
            
        @isTest
        public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            // Given
        
            Case phoneCaseWithAccountContacts = TestDataFactory.createCaseWithAccount('Web', 3);
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(phoneCaseWithAccountContacts, false);

            Test.stopTest();

            // Then
            System.assert(!result.isSuccess(), 'Case should not be created.');
            System.assert(result.getErrors().size() > 0, 'There is no errors occured while creating this Case.');
            System.assertEquals('Web request are only allowed to have one attendee',
            result.getErrors()[0].getMessage(), 'Case does not contain the specified error message.');
        } 

        @isTest
        public static void closeCase(){
            // Given
        
            Case phoneCaseWithAccountContacts = TestDataFactory.createCaseWithAccount('Web', 1);
            
            // When 

            Test.startTest();

            Database.SaveResult result = Database.insert(phoneCaseWithAccountContacts, false);
            phoneCaseWithAccountContacts.Status = 'Closed';
            Database.SaveResult updateResult = Database.update(phoneCaseWithAccountContacts);
            List<Task> tasks = Database.query('SELECT id FROM Task');
            Test.stopTest();

            // Then
            System.assert(updateResult.isSuccess(), 'Case should be updated.');
            System.assert(tasks.size() > 0, 'There should one task created after Case update');
        } 
    
    
}
