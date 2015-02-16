trigger UpdateEmailTemplate on Campaign (before insert, before update) {
	
	Id folder = [Select Id From Folder Where DeveloperName = 'Donation_Thank_Yous'].Id;

	Map<String, Id> templates = new Map<String, Id>();    
	for (EmailTemplate t : [select Id, Name from EmailTemplate Where FolderId =: folder]) {
    	templates.put(t.Name, t.Id);
	}

	for (Campaign c: Trigger.new) {
		if (String.isNotBlank(c.Acknowledgement_Email_Template__c)) {
			c.Acknowledgement_Template_Id__c = templates.get(c.Acknowledgement_Email_Template__c);
		}
	}	
}