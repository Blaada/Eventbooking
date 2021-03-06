/**
 * @author YOUSSEF BLAADA (yblaada@salesforce.com)
 * @date 18 mar 2022
 *
 * @description External System Callout, calls an external service with a Contact,
 * if response is successful ( 201 status ), then we create a Task to send an email to Contact.
 *
 */
public without sharing class ExternalSystemCallout {
    /**
     * @description future callout to external service
     * @param accountIdsSet set of Account Ids
     */
    @future(callout=true)
    public static void makeCallout(Set<Id> accountIdsSet, Id handledCaseId) {
        if(!Schema.sObjectType.Contact.isQueryable()){
            return;
        }
        List<Contact> contactList = [SELECT id,name, email, AccountId FROM Contact where accountid IN : accountIdsSet ];
        for(Contact contact: contactList) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ExternalServiceUrl/animals');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');    
            // Set the body as a JSON object
            request.setBody('{"name":"'+ contact.name + '-' + contact.email  +'"}');
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if (response.getStatusCode() != 201) {
                Logger.error('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
            } else {
                // Everything went as expected.
                notifyAttendeeByEmail(contact, handledCaseId);
            }
        }
    }

    /**
     * @description Notify attendee by email ( task + email )
     * @param contact create Task for this contact
     */
    public static void notifyAttendeeByEmail(Contact contact, Id handledCaseId){
        if(!Schema.sObjectType.Task.isCreateable()){
            return;
        }
        Task task = new Task();
        task.Subject = 'Send Email To' + contact.name;
        task.Status = 'Open';
        task.Priority = 'Normal';
        task.WhoId = contact.Id;
        task.WhatId = contact.AccountId;
        insert task;
        sendMail(contact.email, handledCaseId);
    } 

    public static void sendMail(String contactEmail, Id caseId) {
        // getting domain url
        String caseLink = URL.getSalesforceBaseUrl().toExternalForm() + '/' + caseId;
        // reserve email capacity for the current Apex transaction
        Messaging.reserveSingleEmailCapacity(2);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {contactEmail};
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Case Closed');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody('Your case: <b> ' + caseId +' </b> has been closed. <p>'+
     'To view your case <a href='+caseLink+'>click here.</a>');  
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
