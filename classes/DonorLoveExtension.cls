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
}