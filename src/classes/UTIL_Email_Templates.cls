public with sharing class UTIL_Email_Templates {
	public class UTIL_Email_Templates_Exception extends exception {}

	// Derived from: 
	// http://salesforce.stackexchange.com/questions/13/using-apex-to-assemble-html-letterhead-emails/8745#8745 and http://salesforce.stackexchange.com/questions/48306/how-to-avoid-to-send-the-mail-to-owner-field?lq=1
	public static Messaging.SingleEmailMessage MergeTemplateWithoutSending(Id targetObjectId, Id whatId, Id templateId, String senderDisplayName) {
		Messaging.reserveSingleEmailCapacity(1);
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		// Intentionally set a bogus email address.
		String[] toAddresses = new String[]{'invalid@emailaddr.es'};
		mail.setToAddresses(toAddresses);
		mail.setUseSignature(false);
		mail.setSaveAsActivity(false);
		mail.setSenderDisplayName(senderDisplayName);
		mail.setTargetObjectId(targetObjectId);
		mail.setWhatId(whatId);
		mail.setTemplateId(templateId);

		// create a save point
		Savepoint sp = Database.setSavepoint();
		// Force the merge of the template.
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
		// Force a rollback, and cancel mail send.
		Database.rollback(sp);

		// Return the mail object
		// You can access the merged template, subject, etc. via:
		// String mailTextBody = mail.getPlainTextBody();
		// String mailHtmlBody = mail.getHTMLBody();
		// String mailSubject = mail.getSubject();
		return mail;
	}

	public static Messaging.SingleEmailMessage SendPlainTextMessage(Id targetObjectId, Id whatId, String subject, String body, String senderDisplayName) {
		Messaging.reserveSingleEmailCapacity(1);
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setUseSignature(false);
		mail.setSaveAsActivity(false); // the activity will be logged manually so to hit the appropriate recordtype
		mail.setSenderDisplayName(senderDisplayName);
		mail.setTargetObjectId(targetObjectId);
		mail.setWhatId(whatId);
		mail.setPlainTextBody(body);
		mail.setSubject(subject);

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
		return mail;
	}
}