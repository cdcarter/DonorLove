public with sharing class UTIL_Contact_Preferences {
	public static String getEmail(Contact contact) {
		if (contact.npe01__Preferred_Email__c == 'Home') {
			return contact.npe01__HomeEmail__c;
		} else if (contact.npe01__Preferred_Email__c == 'Work') {
			return contact.npe01__WorkEmail__c;
		} else if (contact.npe01__Preferred_Email__c == 'Alternate') {
			return contact.npe01__AlternateEmail__c;
		} else {
			return '';
		}
	}

	public static String getPhone(Contact contact) {
		if (contact.npe01__PreferredPhone__c == 'Home') {
			return contact.HomePhone;
		} else if (contact.npe01__PreferredPhone__c == 'Work') {
			return contact.npe01__WorkPhone__c;
		} else if (contact.npe01__PreferredPhone__c == 'Mobile') {
			return contact.MobilePhone;
		} else if (contact.npe01__PreferredPhone__c == 'Other') {
			return contact.OtherPhone;
		} else {
			return '';
		}
	}
}