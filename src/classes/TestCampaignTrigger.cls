@isTest
private class TestCampaignTrigger {
	
	@isTest static void test_insert() {
		EmailTemplate x = [Select Id,Name From EmailTemplate Where DeveloperName = 'Annual_Fund_Thank_You'];
		Campaign c = new Campaign(Name='TestCampaign', Acknowledgement_Email_Template__c ='Annual Fund Thank You');
		test.startTest();
		insert c;
		test.stopTest();
		
		// there's a more elegant way to do this?
		Campaign r = [Select Id,Acknowledgement_Template_Id__c,Name from Campaign Where Name = 'TestCampaign'];
		System.assertEquals(r.Acknowledgement_Template_Id__c,x.Id);
	}
}