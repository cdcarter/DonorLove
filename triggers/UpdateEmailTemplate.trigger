trigger UpdateEmailTemplate on Campaign (before insert, before update) {

	Id folder = [Select Id From Folder Where DeveloperName = 'Donation_Thank_Yous'].Id;

	for (Campaign c: Trigger.new) {
		if (String.isNotBlank(c.Acknowledgement_Email_Template__c)) {
			c.Acknowledgement_Template_Id__c = [SELECT Id 
												FROM EmailTemplate 
												WHERE FolderId =: folder 
												AND Name =: c.Acknowledgement_Email_Template__c].Id;
		}
	}	
}