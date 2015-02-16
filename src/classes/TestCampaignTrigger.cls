@isTest
private class TestCampaignTrigger {
	
	@isTest static void test_insert() {
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
			Id folder = [Select Id From Folder Where DeveloperName = 'Donation_Thank_Yous'].Id;

			EmailTemplate x = new EmailTemplate(FolderId = folder, 
												Name = 'ThankYa', DeveloperName='ThankYa', 
												TemplateType='Text',
												IsActive = true,
												Subject = 'Test Email');
			insert x;
		}

		EmailTemplate x = [Select Id,Name From EmailTemplate Where Name = 'ThankYa'];
		Campaign c = new Campaign(Name='TestCampaign', Acknowledgement_Email_Template__c ='ThankYa');
		test.startTest();
		insert c;
		test.stopTest();
		System.assertEquals(c.Acknowledgement_Template_Id__c,x.Id);
	}
}