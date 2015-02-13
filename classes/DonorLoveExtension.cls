public class DonorLoveExtension {
	Opportunity opp;
   private ApexPages.StandardController sc;
   public String mergedEmail {get; set;}
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

   public PageReference ToEmail() {
      this.mergedEmail = UTIL_Email_Templates.MergeTemplateWithoutSending(getPrimaryContact().Id, opp.Id, (Id)emailId, 'Test Sender').getPlainTextBody();
      return Page.LOVE_Email;
   }
}