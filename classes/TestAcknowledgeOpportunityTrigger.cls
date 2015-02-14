@isTest
private class TestAcknowledgeOpportunityTrigger {
	
	@isTest static void test_on_create() {
        
        Account acc = new Account(Name='test77');
        insert acc;
        
        String title = 'CEO';
        Contact con = new Contact(
            FirstName='Blah',
            LastName='Whatever',
            Title=title,
            AccountId = acc.Id,
            npe01__WorkEmail__c = 'blah@whatever.test', 
            npe01__Preferred_Email__c = 'Work',
            npe01__WorkPhone__c = '(206) 555-1212',
            npe01__PreferredPhone__c = 'Work'
        );
        insert con;

        Opportunity opp = new Opportunity(
            Name = 'Apex Test Opp2',
            AccountId = acc.Id,
            npe01__Contact_Id_for_Role__c = con.Id,
            CloseDate = date.today(), StageName = 'Closed Won'
        );
        insert opp;

        test.startTest();

        Task task = new Task(
        	RecordTypeId = npsp.UTIL_RecordTypes_API.GetRecordTypeId('Task','Acknowledgement'),
        	WhatId = opp.id,
        	WhoId = con.id,
        	Subject = 'Email',
        	Description = 'An email',
        	Status = 'Completed'
        );
        insert task;

        test.stopTest();

        opp = [Select Id,Acknowledged__c From Opportunity Where Id =: opp.Id];

        System.assert(opp.Acknowledged__c);
	}
	
	@isTest static void test_on_update() {
		// Implement test code
	}
	
}