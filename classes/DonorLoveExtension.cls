public class DonorLoveExtension {
	Opportunity opp;

	public DonorLoveExtension(ApexPages.standardController std){
		opp = (Opportunity)std.getRecord();
	}

	public Contact getPrimaryContact() {
		List<OpportunityContactRole> primary = [Select ContactId
												From OpportunityContactRole
												Where IsPrimary = true
												and OpportunityId =: opp.id];
		return [Select Name, npe01__WorkEmail__c, npe01__HomeEmail__c, npe01__AlternateEmail__c, npe01__Preferred_Email__c, npe01__PreferredPhone__c, npe01__WorkPhone__c, MobilePhone, OtherPhone, HomePhone, MailingCity, MailingState
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
}