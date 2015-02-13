public class DonorLoveExtension {
	Opportunity opp;
   private ApexPages.StandardController sc;
   public String mergedEmailBody {get; set;}
   public String mergedEmailSubject {get; set;}
   public String emailId {get; set;}

	public DonorLoveExtension(ApexPages.standardController std){
      sc = std;
		opp = (Opportunity)std.getRecord();
	}

	public Contact getPrimaryContact() {
		List<OpportunityContactRole> primary = [Select ContactId
												From OpportunityContactRole
												Where IsPrimary = true
												and OpportunityId =: opp.id];
		return [Select Id, Name, npe01__WorkEmail__c, npe01__HomeEmail__c, npe01__AlternateEmail__c, npe01__Preferred_Email__c, npe01__PreferredPhone__c, npe01__WorkPhone__c, MobilePhone, OtherPhone, HomePhone, MailingCity, MailingState
				From Contact
				Where Id =: primary[0].ContactId];
   }

   public String getPrimaryContactEmail() {
   		Contact c = getPrimaryContact();
   		return UTIL_Contact_Preferences.getEmail(c);
   }

   public String getPrimaryContactPhone() {
   		Contact c = getPrimaryContact();
   		return UTIL_Contact_Preferences.getPhone(c);
   }

   public List<EmailTemplate> getEmailTemplates() {
   		Id folder = [Select Id From Folder Where DeveloperName = 'Donation_Thank_Yous'].Id;
   		return [Select Name,DeveloperName,Id from EmailTemplate Where FolderId = :folder];
   }

   // Page Navigation
   public PageReference ToStart() {
      return Page.LOVE_Start;
   }

   // the test email I was using didn't have a html template, so I switched here to plain text body. Probably need to handle that properly...
   public PageReference ToEmail() {
      Messaging.SingleEmailMessage mail = UTIL_Email_Templates.MergeTemplateWithoutSending(getPrimaryContact().Id, opp.Id, (Id)emailId, 'Test Sender');
      this.mergedEmailBody = mail.getPlainTextBody();
      this.mergedEmailSubject = mail.getSubject();
      return Page.LOVE_Email;
   }

   public PageReference SendEmail() {
      // send the message
      Messaging.SingleEmailMessage mail = UTIL_Email_Templates.SendPlainTextMessage(getPrimaryContact().Id, opp.Id, mergedEmailSubject, mergedEmailBody, UserInfo.getName());

      // create a completed task
      Task task = new Task();
      task.OwnerId = UserInfo.getUserId();
      task.WhatId = opp.id;
      task.WhoId = getPrimaryContact().Id;
      task.Status = 'Completed';
      task.Description = mergedEmailBody;
      task.Subject = mergedEmailSubject;
      task.RecordTypeId = npsp.UTIL_RecordTypes_API.GetRecordTypeId('Task','Acknowledgement');

      insert task;

      // mark the opportunity as acknowledged MAYBE MAKE A WORKFLOW
      opp.Acknowledged__c = true;
      update opp;

      // return to the opportunity view
      return sc.view();
   }
}