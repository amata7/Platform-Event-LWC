trigger contactMessage on Contact (after insert) {
    if (Trigger.isInsert) {
        List<Contact_Updated__e> platformMessage = new List<Contact_Updated__e>();
        for (Contact c : Trigger.new) {
            platformMessage.add(new Contact_Updated__e(First_Name__c = c.FirstName, Last_Name__c = c.LastName));
        }
        List<Database.SaveResult> results = EventBus.publish(platformMessage);
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }       
        }

    }
}