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
		return [Select Name, npe01__WorkEmail__c, HomePhone, MailingCity, MailingState
				From Contact
				Where Id =: primary[0].ContactId];
   }

   public List<EmailTemplate> getEmailTemplates() {
   		Id folder = [Select Id From Folder Where DeveloperName = 'Donation_Thank_Yous'].Id;
   		return [Select Name,DeveloperName,Id from EmailTemplate Where FolderId = :folder];
   }
}